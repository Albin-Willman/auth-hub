# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(255)
#  password_digest :string(255)
#  token           :string(255)
#  active          :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe 'Users API' do
  let(:user) { create(:user) }

  context 'login' do
    it 'can log in an existing active user' do
      user.activate!('12345')
      post '/api/v1/users/login',
           user: {
             email: user.email,
             password: '12345'
           },
           service: 'test-request'
      expect(response).to be_success

      expect(json['data']['type']).to eq('tokens')
      expect(json['data']['attributes']['service']).to eq('test-request')
      expect(json['data']['attributes']['token']).to_not be_nil
    end

    it 'can not log in an existing inactive user' do
      post '/api/v1/users/login',
           user: {
             email: user.email,
             password: '123456'
           },
           service: 'test-request'
      expect(response).to have_http_status(422)
      expect(response.body).to eq('false')
    end

    it 'can not log in an non existing user' do
      post '/api/v1/users/login',
           user: {
             email: 'dummy_email@example.com',
             password: '123456'
           },
           service: 'test-request'
      expect(response).to have_http_status(422)
      expect(response.body).to eq('false')
    end
  end

  context 'logout' do
    it 'can log out a logged in user' do
      token = create(:token)
      delete '/api/v1/users/logout',
             { service: 'rspec' },
             authorization: build_auth(token.token)

      expect(response).to be_success
      expect(response.body).to eq('{"data":true}')

      expect(Token.find_by(id: token.id)).to be_nil
    end

    it 'can not log a user from a service that it is not logged in to' do
      token = create(:token)
      delete '/api/v1/users/logout',
             { service: 'dummy-service' },
             authorization: build_auth(token.token)

      expect(response).to have_http_status(422)
      expect(response.body).to eq('false')

      expect(Token.find_by(id: token.id)).to_not be_nil
    end

    it 'can not log out a user if the request is unauthed' do
      delete '/api/v1/users/logout',
             { service: 'rspec' },
             authorization: build_auth('badtoken')

      expect(response).to have_http_status(401)
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end

  context 'destroy' do
    it 'can destroy an authed user' do
      token = create(:token)
      delete '/api/v1/users', nil,
             authorization: build_auth(token.token)

      expect(response).to be_success
      expect(response.body).to eq('true')

      expect(Token.find_by(id: token.id)).to be_nil
      expect(User.find_by(id: token.user_id)).to be_nil
    end

    it 'can not destroy an unauthed user' do
      delete '/api/v1/users', nil,
             authorization: build_auth(user.token)

      expect(response).to have_http_status(401)
      expect(response.body).to eq("HTTP Token: Access denied.\n")

      expect(User.find_by(id: user.id)).to_not be_nil
    end

    it 'returns the correct errors if something is wrong' do
      Api::V1::ApplicationController.any_instance.stub(:current_user).and_return(NilUser.new)
      token = create(:token)
      delete '/api/v1/users', nil,
             authorization: build_auth(token.token)
      expect(response).to have_http_status(422)
      expect(response.body).to eq('{"errors":[{"id":"user","title":"User No user"}]}')
    end
  end

  context 'update' do
    it 'can update a user' do
      token = create(:token)
      user_hash = {
        name: 'new name',
        email: 'new_email@example.com',
        password: 'asdasd'
      }
      patch '/api/v1/users', { user: user_hash },
            authorization: build_auth(token.token)
      expect(response).to be_success
      updated_user = User.find(token.user_id)
      verify_user_data(json['data'], updated_user, user_hash)
    end

    it 'can not update a user if the email is taken' do
      token = create(:token)
      blocking_user = create(:user, email: 'blocking_email@example.com')
      patch '/api/v1/users',
            {
              user: {
                name: 'new name',
                email: blocking_user.email,
                password: 'asdasd'
              }
            },
            authorization: build_auth(token.token)

      expect(response).to have_http_status(422)
      expect(json['errors'].length).to eq(1)
      error = json['errors'].first
      expect(error['id']).to eq('email')
      expect(error['title']).to eq('Email has already been taken')
    end
  end

  context 'activation' do
    it 'can find an inactivate user by its token' do
      expect(user.active).to be_falsy
      get "/api/v1/users/#{user.token}/activate"

      user.reload
      expect(user.active).to be_falsy
      expect(response).to be_success
      expect(json['data']['attributes']['email']).to eq('test@example.com')
    end

    it 'can not find a user with a faulty token' do
      get "/api/v1/users/#{user.token}-fault/activate"
      user.reload
      expect(user.active).to be_falsy
      expect(response).to have_http_status(422)
      expect(response.body).to eq('{"activated":false}')
    end

    context 'perform activation' do
      it 'can activate an inactivate user by its token' do
        expect(user.active).to be_falsy
        patch "/api/v1/users/#{user.token}/activate", { user: { password: '123456' } }

        user.reload
        expect(user.active).to be_truthy
        expect(response).to be_success
        expect(json['data']['attributes']['email']).to eq('test@example.com')
      end

      it 'sets the password on activation' do
        expect(user.authenticate('123456')).to eq(false)
        patch "/api/v1/users/#{user.token}/activate", { user: { password: '123456' } }
        expect(response).to be_success
        user.reload
        expect(user.authenticate('123456')).to eq(user)
      end

      it 'can not activate a user with a faulty token' do
        patch "/api/v1/users/#{user.token}-fault/activate", { user: { password: '123456' } }
        user.reload
        expect(user.active).to be_falsy
        expect(response).to have_http_status(422)
        expect(response.body).to eq('{"activated":false}')
      end
    end
  end

  context 'create' do
    it 'can create a new user without auth' do
      user_hash = {
        name: 'new name',
        email: 'new_email@example.com',
        password: 'asdasd'
      }
      post '/api/v1/users', user: user_hash
      expect(response).to be_success
      new_user = User.find(json['data']['id'])
      verify_user_data(json['data'], new_user, user_hash)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      mail = ActionMailer::Base.deliveries.last
      link = ActivationLinkBuilder.new('http://test/', new_user).build
      expect(mail.body.encoded).to include(link)
      expect(mail.to).to eq([new_user.email])
      expect(mail.from).to eq(['salbin.reminders@gmail.com'])
    end

    it 'fails if the email is taken' do
      blocking_user = create(:user, email: 'blocking_email@example.com')
      user_hash = {
        name: 'new name',
        email: blocking_user.email,
        password: 'asdasd'
      }
      post '/api/v1/users', user: user_hash

      expect(response).to have_http_status(422)
      expect(json['errors'].length).to eq(1)
      error = json['errors'].first
      expect(error['id']).to eq('email')
      expect(error['title']).to eq('Email has already been taken')
    end
  end

  def verify_user_data(data, db_user, user_hash)
    verify_user_data_basics(data, db_user)
    verify_user_attributes(data['attributes'], user_hash)
    db_user.reload
    verify_active_record_user(db_user, user_hash)
  end

  def verify_user_data_basics(data, db_user)
    expect(data['type']).to eq('users')
    expect(data['id']).to eq(db_user.id.to_s)
  end

  def verify_active_record_user(db_user, user_hash)
    expect(db_user.name).to eq(user_hash[:name])
    expect(db_user.email).to eq(user_hash[:email])
    expect(db_user.authenticate(user_hash[:password])).to be_truthy
  end

  def verify_user_attributes(attributes, user_hash)
    expect(attributes.length).to eq(2)
    expect(attributes['name']).to eq(user_hash[:name])
    expect(attributes['email']).to eq(user_hash[:email])
  end
end

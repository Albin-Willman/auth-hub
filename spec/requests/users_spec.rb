require 'rails_helper'

describe 'Users API' do
  let(:user) { create(:user) }

  context 'login' do
    it 'can log in an existing active user' do
      user.activate!
      post '/api/v1/users/login',
           user: {
             email: user.email,
             password: '123456'
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
      expect(response.body).to eq('true')

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
  end

  context 'update' do
    it 'can update a user' do
      token = create(:token)
      patch '/api/v1/users',
            {
              user: {
                name: 'new name',
                email: 'new_email@example.com',
                password: 'asdasd'
              }
            },
            authorization: build_auth(token.token)
      expect(response).to be_success
      data = json['data']
      expect(data['type']).to eq('users')
      expect(data['id']).to eq(token.user_id.to_s)
      attributes = data['attributes']
      expect(attributes.length).to eq(2)
      expect(attributes['name']).to eq('new name')
      expect(attributes['email']).to eq('new_email@example.com')

      updated_user = User.find(token.user_id)

      expect(updated_user.name).to eq('new name')
      expect(updated_user.email).to eq('new_email@example.com')
      expect(updated_user.authenticate('asdasd')).to be_truthy
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
end

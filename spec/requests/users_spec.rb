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
      delete "/api/v1/users/logout",
             { service: 'rspec' },
             authorization: build_auth(token.token)

      expect(response).to be_success
      expect(response.body).to eq('true')

      expect(Token.find_by(id: token.id)).to be_nil
    end

    it 'can not log a user from a service that it is not logged in to' do
      token = create(:token)
      delete "/api/v1/users/logout",
             { service: 'dummy-service' },
             authorization: build_auth(token.token)

      expect(response).to have_http_status(422)
      expect(response.body).to eq('false')

      expect(Token.find_by(id: token.id)).to_not be_nil
    end

    it 'can not log out a user if the request is unauthed' do
      token = create(:token)
      delete "/api/v1/users/logout",
             { service: 'rspec' },
             authorization: build_auth('badtoken')

      expect(response).to have_http_status(401)
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end
end

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
end

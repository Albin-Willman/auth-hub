# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  service    :string(255)
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_ac8a5d0441  (user_id => users.id)
#

require 'rails_helper'

describe 'Tokens API' do
  context 'index' do
    it 'retrieves a token list' do
      token = FactoryGirl.create(:token)
      FactoryGirl.create(:token, user: token.user)
      get '/api/v1/users/tokens', nil,
          authorization: build_auth(token.token)

      # test for the 200 status-code
      expect(response).to be_success

      # check that the message attributes are the same.
      expect(json['data'].length).to eq(2)
      res = json['data'].first
      expect(res['attributes']['token']).to eq(token.token)
      expect(res['attributes']['service']).to eq(token.service)

      # ensure that private attributes aren't serialized
      expect(json['private_attr']).to eq(nil)
    end

    it 'fails if it has a bad token' do
      token = FactoryGirl.create(:token)
      FactoryGirl.create(:token, user: token.user)
      get '/api/v1/users/tokens', nil,
          authorization: build_auth('badtoken')
      expect(response).to have_http_status(401)
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end

  context 'verify' do
    it 'verifies a correct token' do
      token = FactoryGirl.create(:token)
      FactoryGirl.create(:token, user: token.user)
      get '/api/v1/verify', nil,
          authorization: build_auth(token.token)

      # test for the 200 status-code
      expect(response).to be_success

      # check that the message attributes are the same.
      res = json['data']
      expect(res['type']).to eq('users')
      expect(res['attributes']['email']).to eq('test@example.com')
    end

    it 'fails if it has a bad token' do
      token = FactoryGirl.create(:token)
      FactoryGirl.create(:token, user: token.user)
      get '/api/v1/verify', nil,
          authorization: build_auth('badtoken')
      expect(response).to have_http_status(401)
      expect(response.body).to eq("HTTP Token: Access denied.\n")
    end
  end
end

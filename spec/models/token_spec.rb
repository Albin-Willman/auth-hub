require 'rails_helper'

describe Token do
  let(:token) { create(:token) }

  it 'has a valid factory' do
    expect(token.service).to eq('rspec')
    expect(token.user).to be_a(User)
  end
end

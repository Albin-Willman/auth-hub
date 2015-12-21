require 'rails_helper'

describe ActivationLinkBuilder do
  let(:user) { create(:user) }
  let(:domain) { 'http://dummy.com' }

  it 'builds a link' do
    res = described_class.new(domain, user).build
    expect(res).to start_with(domain)
  end

  it 'contains the token' do
    res = described_class.new(domain, user).build
    expect(res).to include(user.token)
  end

  it 'contains the api path' do
    res = described_class.new(domain, user).build
    expect(res).to include('/api/v1/')
  end
end

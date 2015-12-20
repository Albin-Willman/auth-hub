require 'rails_helper'

describe TokenSerializer do
  let(:token) { create(:token) }
  let(:subject) { described_class.new(token) }

  it 'includes a user_id' do
    expect(subject.serializable_hash[:user_id]).to_not be_nil
  end

  it 'includes a token' do
    expect(subject.serializable_hash[:token].length).to eq(24)
  end

  it 'includes a service' do
    expect(subject.serializable_hash[:service]).to eq('rspec')
  end

  it 'includes a created_at' do
    now = Time.zone.today
    expect(subject.serializable_hash[:created_at].to_date).to eq(now)
  end
end

require 'rails_helper'

describe UserSerializer do
  let(:user) { create(:user) }
  let(:subject) { described_class.new(user) }
  it 'includes the id' do
    expect(subject.serializable_hash[:id]).to_not be_nil
  end

  it 'includes the email' do
    expect(subject.serializable_hash[:email]).to eq('test@example.com')
  end

  it 'includes the name' do
    expect(subject.serializable_hash[:name]).to eq('Albin')
  end
end

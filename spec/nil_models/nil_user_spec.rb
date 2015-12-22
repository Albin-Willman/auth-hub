require 'rails_helper'

describe NilUser do
  let(:subject) { described_class.new }
  it 'cannot be destroyed' do
    expect(subject.destroy).to be_falsey
  end

  it 'cannot be updated' do
    expect(subject.update_attributes(test: 'my_test')).to be_falsey
  end

  it 'has no tokens' do
    expect(subject.tokens.any?).to be_falsey
  end

  it 'has can not be activated' do
    expect(subject.activate!).to be_falsey
  end

  it 'has an error' do
    expect(subject.errors).to eq(['No user'])
  end
end

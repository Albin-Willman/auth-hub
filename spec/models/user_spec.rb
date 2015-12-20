require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  it 'The factories work' do
    expect(user.name).to eq('Albin')
    expect(user.email).to eq('test@example.com')
  end
  context 'Activation' do
    it 'Can be activated' do
      expect(user.active).to eq(false)
      user.activate!
      expect(user.active).to eq(true)
    end

    it 'Gets a new token when activated' do 
      token = user.token
      user.activate!
      expect(user.token).to_not eq(token)
    end

    it 'Has a scope that only find active users' do
      user1 = user
      user2 = FactoryGirl.create(:user, email: 'test2@example.com')
      user1.activate!
      expect(User.count).to eq(2)
      expect(User.active.count).to eq(1)
    end
  end
end
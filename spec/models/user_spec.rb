require 'rails_helper'

describe User do
  let(:user) { create(:user) }
  it 'The factories work' do
    expect(user.name).to eq('Albin')
    expect(user.email).to eq('test@example.com')
    expect(user.valid?).to be_truthy
  end

  context 'find_by_token' do
    it 'finds a user if it has a correct token' do
      res = described_class.find_by_token(user.token)
      expect(res).to eq(user)
    end

    it 'returns a nil user if it has a bad token' do
      res = described_class.find_by_token(user.token + 'fault')
      expect(res).to be_a(NilUser)
    end

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
      create(:user, email: 'test2@example.com')
      user1.activate!
      expect(User.count).to eq(2)
      expect(User.active.count).to eq(1)
    end
  end

  context 'Authentification' do
    it 'can verify a correct password' do
      expect(user.authenticate('123456')).to eq(user)
    end

    it 'can refute a bad password' do
      expect(user.authenticate('asdasdasd')).to eq(false)
    end
  end
end

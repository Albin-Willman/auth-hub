require 'rails_helper'

describe Token do
  let(:token) { create(:token) }

  it 'has a valid factory' do
    expect(token.service).to eq('rspec')
    expect(token.user).to be_a(User)
  end
end

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

# Used to build JSON responses for users
class TokenSerializer < ActiveModel::Serializer
  attributes :id, :service, :token, :user_id, :created_at
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

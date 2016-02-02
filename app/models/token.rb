# All valid tokens used to auth users
class Token < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  has_secure_token
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

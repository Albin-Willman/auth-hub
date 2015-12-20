# Users
class User < ActiveRecord::Base
  has_secure_password
  has_secure_token
  validates :email, uniqueness: true, presence: true
  has_many :tokens, dependent: :destroy

  scope :active, -> { where(active: true) }

  def activate!
    update_attributes!(active: true)
    regenerate_token && true
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  name            :string(255)
#  password_digest :string(255)
#  token           :string(255)
#  active          :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

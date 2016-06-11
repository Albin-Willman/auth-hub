require 'securerandom'
# Users
class User < ActiveRecord::Base
  has_secure_password
  has_secure_token
  validates :email, uniqueness: true, presence: true
  has_many :tokens, dependent: :destroy

  before_validation :set_random_password

  scope :active, -> { where(active: true) }

  def self.find_by_token(token)
    find_by(token: token) || NilUser.new
  end

  def activate!(new_password)
    update_attributes!(active: true, password: new_password)
    regenerate_token && true
  end

  private

  def set_random_password
    self.password = SecureRandom.base64(50) if password.blank?
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

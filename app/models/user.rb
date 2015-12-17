# Users
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.merge_validates_length_of_password_field_options(minimum: 8)
  end
end

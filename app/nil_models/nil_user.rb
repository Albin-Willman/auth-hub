# Class to act as user if no user is present
class NilUser
  def destroy
    false
  end

  def update_attributes(*_attrs)
    false
  end

  def errors
    error = ActiveModel::Errors.new(User.new)
    error.add(:user, 'No user')
    error
  end

  def tokens
    Token.none
  end

  def activate!(_)
    false
  end

  def persisted?
    false
  end
end

# Class to act as user if no user is present
class NilUser
  def destroy
    false
  end

  def update_attributes(*_attrs)
    false
  end

  def errors
    ['No user']
  end

  def tokens
    Token.none
  end
end

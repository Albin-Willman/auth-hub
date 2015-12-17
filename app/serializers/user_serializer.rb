# Used to build JSON responses for users
class UserSerializer < ActiveModel::Serializer
  attributes :email, :id, :token

  def token
    object.persistence_token
  end
end

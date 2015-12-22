# Used to build JSON responses for users
class TokenSerializer < ActiveModel::Serializer
  attributes :id, :service, :token, :user_id, :created_at, :my_test

  def my_test
    asdasd
  end
end

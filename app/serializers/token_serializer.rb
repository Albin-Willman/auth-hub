# Used to build JSON responses for users
class TokenSerializer < ActiveModel::Serializer
  attributes :id, :service, :token, :user_id, :created_at
end

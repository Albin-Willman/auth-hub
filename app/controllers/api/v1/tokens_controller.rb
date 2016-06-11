module Api
  module V1
    # Handle requests concerning users
    class TokensController < Api::V1::ApplicationController
      before_action :authenticate

      api :GET, '/v1/users/:user_id/tokens', 'List tokens'
      description 'Lists all tokens for a user.'
      def index
        render json: current_user.tokens, status: :ok
      end

      api :GET, '/v1/verify', 'Verify token'
      description 'Verifies that a token exists'
      def verify
        render json: current_user, status: :ok
      end
    end
  end
end

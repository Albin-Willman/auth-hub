module Api
  module V1
    # Handle requests concerning users
    class TokensController < Api::V1::ApplicationController
      before_action :authenticate
      before_action :find_user, except: [:verify]

      api :GET, '/v1/users/:user_id/tokens', 'List tokens'
      description 'Lists all tokens for a user.'
      def index
        render json: @user.tokens, status: :ok
      end

      api :GET, '/v1/verify', 'Verify token'
      description 'Verifies that a token exists'
      def verify
        render json: { verified: true }, status: :ok
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      end
    end
  end
end

module Api
  module V1
    # Handle requests concerning activation
    class ActivationController < Api::V1::ApplicationController
      api :GET, '/v1/users/:token/activate', 'Activate user'
      description 'Activates a user acount.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :password, String, desc: 'Password', required: true
      end
      def perform_activation
        @user = User.find_by_token(params[:token])
        if @user.activate!(params[:user][:password])
          render json: @user, status: :ok
        else
          render json: { activated: false }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/users/:token/activate', 'Activate user'
      description 'Fetches an inactive user.'
      def activate
        @user = User.find_by_token(params[:token])
        if @user.persisted?
          render json: @user, status: :ok
        else
          render json: { activated: false }, status: :unprocessable_entity
        end
      end
    end
  end
end

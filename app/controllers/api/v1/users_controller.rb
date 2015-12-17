module Api
  module V1
    # Handle requests concerning users
    class UsersController < Api::V1::ApplicationController
      api :POST, '/v1/users/', 'Create new user'
      description 'Creates and returns a new user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
      end
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/users/', 'Update user'
      description 'Updates and returns a user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
      end
      def update
        if @user && @user.update_attributes(user_params)
          render json: @user, status: :updated
        else
          render json: @user && @user.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/users/', 'Delete user'
      description 'Deletes a user if authorized.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :Password, String, desc: 'Password', required: true
      end
      def destroy
        if @user && @user.destroy
          render json: true, status: :destroyed
        else
          render json: false, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end

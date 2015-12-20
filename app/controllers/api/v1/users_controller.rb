module Api
  module V1
    # Handle requests concerning users
    class UsersController < Api::V1::ApplicationController
      before_action :find_user, except: [:create, :activate, :login]

      api :POST, '/v1/users/', 'Create new user'
      description 'Creates and returns a new user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
        param :name, String, desc: 'Name'
      end
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :GET, '/v1/users/:token/activate', 'Activate user'
      description 'Activates a user acount.'
      def activate
        @user = User.find_by(token: params[:token])
        if @user && @user.activate!
          render json: { activated: true }, status: :ok
        else
          render json: { activated: false }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/users/:id', 'Update user'
      description 'Updates and returns a user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
        param :name, String, desc: 'Name'
      end
      def update
        if @user && @user.update_attributes(user_params)
          render json: @user, status: :updated
        else
          render json: @user && @user.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/users/:id', 'Delete user'
      description 'Deletes a user if authorized.'
      def destroy
        if @user && @user.destroy
          render json: true, status: :destroyed
        else
          render json: false, status: :unprocessable_entity
        end
      end

      api :POST, '/v1/users/login', 'Login'
      description 'Authorizes a user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
      end
      param :service, String, desc: 'The service you are loging in from.'
      def login
        user = User.where(active: true).find_by(email: user_params[:email])
        if user && user.authenticate(user_params[:password])
          render json: find_or_create_token(user, params[:service]), status: :ok
        else
          render json: false, status: :unprocessable_entity
        end
      end

      private

      def find_or_create_token(user, service)
        token = Token.find_or_initialize_by(user: user, service: params[:service])
        token.save && token
      end

      def find_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password, :name)
      end
    end
  end
end

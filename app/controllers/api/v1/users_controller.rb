module Api
  module V1
    # Handle requests concerning users
    class UsersController < Api::V1::ApplicationController
      include ErrorSerializer
      NON_USER_ACTIONS = [:create, :activate, :login]
      before_action :authenticate, except: NON_USER_ACTIONS

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
          UserMailer.activation_email(@user).deliver_now
          render json: @user, status: :created
        else
          render json: ErrorSerializer.serialize(@user.errors),
                 status: :unprocessable_entity
        end
      end

      api :GET, '/v1/users/:token/activate', 'Activate user'
      description 'Activates a user acount.'
      def activate
        @user = User.find_by_token(params[:token])
        if @user.activate!
          render json: { activated: true }, status: :ok
        else
          render json: { activated: false }, status: :unprocessable_entity
        end
      end

      api :PATCH, '/v1/users/', 'Update user'
      description 'Updates and returns a user.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :email, String, desc: 'Email'
        param :password, String, desc: 'Password'
        param :name, String, desc: 'Name'
      end
      def update
        if current_user.update_attributes(user_params)
          render json: current_user, status: :ok
        else
          render json: ErrorSerializer.serialize(current_user.errors),
                 status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/users/', 'Delete user'
      description 'Deletes a user if authorized.'
      def destroy
        if current_user.destroy
          render json: true, status: :ok
        else
          render json: ErrorSerializer.serialize(current_user.errors),
                 status: :unprocessable_entity
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

      api :DELETE, '/v1/users/logout', 'Logout'
      description 'Authorizes a user.'
      param :service, String, desc: 'The service you are loging out from.'
      param :all_services, ['true'],
            desc: 'If true this will log out all services you have active.'
      def logout
        tokens = find_tokens(params[:all_services], params[:service])
        if tokens.any? && tokens.destroy_all
          render json: { data: true }, status: :ok
        else
          render json: false, status: :unprocessable_entity
        end
      end

      private

      def find_tokens(all_services, service)
        return current_user.tokens if all_services
        current_user.tokens.where(service: service)
      end

      def find_or_create_token(user, service)
        token = Token.find_or_initialize_by(user: user, service: service)
        token.save && token
      end

      def user_params
        params.require(:user).permit(:email, :password, :name)
      end
    end
  end
end

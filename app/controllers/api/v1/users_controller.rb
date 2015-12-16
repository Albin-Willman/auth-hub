class Api::V1::UsersController < Api::V1::ApplicationController

  api :POST, '/v1/users/', 'Create new user'
  description 'Creates and returns a new user.'
  param :user, Hash, desc: 'User attributes', required: true do
    # rubocop:disable Metrics/LineLength
    param :email, String, desc: 'Email', required: true
    param :password, String, desc: 'Password', required: true
    # rubocop:enable Metrics/LineLength
  end
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
  end

  api :DELETE, '/v1/users/', 'Create new user'
  description 'Creates and returns a new user.'
  param :user, Hash, desc: 'User attributes', required: true do
    # rubocop:disable Metrics/LineLength
    param :email, String, desc: 'Email', required: true
    param :Password, String, desc: 'Password', required: true
    # rubocop:enable Metrics/LineLength
  end
  def destroy
  end

  private

  def user_params
    logger.debug('************************')
    logger.debug(params)
    logger.debug('************************')
    params.require(:user).permit(:email, :password)
  end
end

module Api
  module V1
    # Base class for handling api requests
    class ApplicationController < ActionController::API
      include ActionController::Serialization
      include ActionController::HttpAuthentication::Token::ControllerMethods

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          @token = Token.find_by(token: token)
        end
      end

      protected

      def current_user
        @user ||= @token.try(:user) || NilUser.new
      end
    end
  end
end

module Api
  module V1
    # Base class for handling api requests
    class ApplicationController < ActionController::API
      include ActionController::Serialization
    end
  end
end

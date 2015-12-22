module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def build_auth(token)
      ActionController::HttpAuthentication::Token.encode_credentials(token)
    end
  end
end

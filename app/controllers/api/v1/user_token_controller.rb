module Api
  module V1
    class UserTokenController < Knock::AuthTokenController
      # Fix for https://github.com/nsarno/knock/issues/208
      skip_before_action :verify_authenticity_token
    end
  end
end

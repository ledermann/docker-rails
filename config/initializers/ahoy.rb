module Ahoy
  class Store < DatabaseStore
    def visit_model
      Visit
    end
  end
end

Ahoy.api = true
Ahoy.server_side_visits = false
Ahoy.geocode = Rails.env.test? ? false : :async
Ahoy.quiet = !Rails.env.development?

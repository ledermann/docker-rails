class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
end

Ahoy.geocode = Rails.env.test? ? false : :async
Ahoy.throttle = !Rails.env.test?
Ahoy.quiet = !Rails.env.development?

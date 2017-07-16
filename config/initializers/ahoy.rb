class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
end

Ahoy.geocode = :async
Ahoy.throttle = !Rails.env.test?

class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
end

if Rails.env.test?
  Ahoy.geocode = false
  Ahoy.throttle = false
else
  Ahoy.geocode = :async
  Ahoy.throttle = true
end

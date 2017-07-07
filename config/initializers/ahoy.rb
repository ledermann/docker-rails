class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
  Ahoy.geocode = :async
end

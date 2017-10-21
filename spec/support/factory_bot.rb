RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Compatibility with Spring
  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#rails-preloaders-and-rspec
  config.before :suite do
    FactoryBot.reload
  end
end

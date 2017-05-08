RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Compatibility with Spring
  # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#rails-preloaders-and-rspec
  config.before :suite do
    FactoryGirl.reload
  end
end

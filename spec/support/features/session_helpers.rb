module Features
  module SessionHelpers
    # Using multiple Capybara sessions in RSpec request specs
    # http://blog.bruzilla.com/2012/04/10/using-multiple-capybara-sessions-in-rspec-request.html
    def in_browser(name)
      old_session = Capybara.session_name

      Capybara.session_name = name
      yield

      Capybara.session_name = old_session
    end
  end
end

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end

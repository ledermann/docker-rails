if ENV['SELENIUM_REMOTE_HOST']
  # Running on Docker
  Capybara.javascript_driver = :selenium_remote_chrome
  Capybara.register_driver :selenium_remote_chrome do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
      desired_capabilities: :chrome)
  end
else
  # Running on local machine
  Capybara.javascript_driver = :chrome
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
  Capybara.asset_host = 'http://localhost:3000'
end

RSpec.configure do |config|
  config.before :each do
    if Capybara.current_driver == :selenium_remote_chrome
      ip = `/sbin/ip route|awk '/scope/ { print $9 }'`.gsub("\n", '')
      Capybara.server_host = ip
      Capybara.server_port = '3000'
      Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
    end
  end

  config.after :each do
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end
end

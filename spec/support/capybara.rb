if ENV['SELENIUM_REMOTE_HOST']
  # Running on Docker
  Capybara.javascript_driver = :selenium_remote_chrome
  Capybara.register_driver :selenium_remote_chrome do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
      desired_capabilities: :chrome
    )
  end
else
  # Running on local machine
  Capybara.javascript_driver = :chrome
  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')

    Capybara::Selenium::Driver.new(app,
      browser: :chrome,
      options: options
    )
  end

  # To use save_and_open_page with CSS and JS loaded, get assets from this host
  # Capybara.asset_host = 'http://localhost:3000'
  Capybara.asset_host = "http://#{ENV['APP_HOST']}"
end

# Use Puma for Capybara, because by default it uses Webrick (which is not compatible with ActionCable)
Capybara.register_server :puma do |app, port, host|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Host: host, Port: port, config_files: ['-'])
end
Capybara.server = :puma

RSpec.configure do |config|
  config.before :each, js: true do
    if Capybara.current_driver == :selenium_remote_chrome
      ip = `/sbin/ip route|awk '/scope/ { print $9 }'`.delete("\n")
      Capybara.server_host = ip
      Capybara.server_port = '3000'
      Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
    end
  end

  config.after :each, js: true do
    errors = page.driver.browser.manage.logs.get(:browser)
    if errors.present?
      message = errors.map(&:message).join("\n")
      raise message
    end

    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.app_host = nil
  end
end

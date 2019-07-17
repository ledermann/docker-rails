Webdrivers.cache_time = 86_400

# To use save_and_open_page with CSS and JS loaded, get assets from this host
Capybara.asset_host = "http://#{ENV['APP_HOST']}"

# Don't show Puma startup message
require 'action_dispatch/system_testing/server'
ActionDispatch::SystemTesting::Server.silence_puma = true

RSpec.configure do |config|
  config.before :each, type: :system do
    driven_by :rack_test
  end

  config.before :each, type: :system, js: true do
    if ENV['SELENIUM_REMOTE_HOST']
      # Docker environment
      driven_by(
        :selenium,
        using: :chrome,
        options: {
          browser: :remote,
          url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
          desired_capabilities: {
            chromeOptions: {
              args: %w[headless],
              w3c: false
            }
          }
        }
      )

      # Find Docker IP address
      docker_ip = `/sbin/ip route|awk '/scope/ { print $7 }'`.strip
      Capybara.server_host = docker_ip
      Capybara.server_port = '3000'
      Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
    else
      # Local environment
      driven_by(
        :selenium,
        using: :chrome,
        options: {
          desired_capabilities: {
            chromeOptions: {
              args: %w[headless],
              w3c: false
            }
          }
        }
      )
    end
  end

  config.after :each, type: :system, js: true do
    page.driver.browser.manage.logs.get(:browser).each do |log|
      case log.message
      when /This page includes a password or credit card input in a non-secure context/
        # Ignore this warning in tests
        next
      else
        message = "[#{log.level}] #{log.message}"
        raise message
      end
    end
  end
end

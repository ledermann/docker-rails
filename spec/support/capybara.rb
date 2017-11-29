# To use save_and_open_page with CSS and JS loaded, get assets from this host
Capybara.asset_host = "http://#{ENV['APP_HOST']}"

RSpec.configure do |config|
  config.before :suite do
    Capybara.server = :puma, { Threads: '0:20', Silent: true }
  end

  config.before :each, type: :system do
    driven_by :rack_test
  end

  config.before :each, type: :system, js: true do
    if ENV['SELENIUM_REMOTE_HOST']
      driven_by :selenium, using: :chrome, options: {
        browser: :remote,
        url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
        desired_capabilities: :chrome
      }

      ip = `/sbin/ip route|awk '/scope/ { print $9 }'`.delete("\n")
      Capybara.server_host = ip
      Capybara.server_port = '3000'
      Capybara.app_host = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
    else
      driven_by :selenium_chrome_headless
    end
  end

  config.after :each, type: :system, js: true do
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

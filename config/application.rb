require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Hack to fix knock gem
require "active_support/core_ext/integer/time"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DockerRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.time_zone = 'Berlin'

    # Allow CORS for API requests
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*',
                 headers: :any,
                 methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
                 expose: ['ETag']
      end
    end

    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater if ENV['RAILS_SERVE_STATIC_FILES'].present?

    config.x.app_email = ENV.fetch('APP_EMAIL', nil)
    config.x.plausible_script = ENV.fetch('PLAUSIBLE_SCRIPT', nil)
    config.x.app_host = ENV.fetch('APP_HOST', nil)
  end
end

require_relative 'version'

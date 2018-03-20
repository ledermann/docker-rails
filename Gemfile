source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0.rc1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'sprockets_uglifier_with_source_maps'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
gem 'active_model_serializers'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'webpacker'
gem 'react-rails'

gem 'slim-rails'
gem 'kaminari'
gem 'redis', '~> 4.0'
gem 'dalli'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'searchkick'
gem 'wicked_pdf'
gem 'bootstrap', '~> 4'
gem 'font-awesome-sass'
gem 'puma', '~> 3.11'
gem 'foreman'
gem 'rack'
gem 'clearance'
gem 'knock'
gem 'simple_form'
gem 'pundit'
gem 'skylight'
gem 'premailer-rails'
gem 'paper_trail'
gem 'ahoy_matey', '~> 2'
gem 'blazer'
gem 'friendly_id'
gem 'stringex'
gem 'trix'
gem 'rollbar'
gem 'punchbox'
gem 'rack-cors', require: 'rack/cors'

# Image uploads
gem 'shrine'
gem 'image_processing'
gem 'mini_magick'
gem 'aws-sdk-s3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Support #save_and_open_page in feature specs
  gem 'launchy'

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'rubocop', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  # gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'letter_opener'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'

  gem 'simplecov', require: false
  gem 'pdf-reader'
  gem 'email_spec'
  gem 'shrine-memory'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

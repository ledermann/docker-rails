source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.0'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Puma as the app server
gem 'puma', '~> 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
gem 'panko_serializer'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'slim-rails'
gem 'kaminari'
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'

gem 'searchkick'
gem 'opensearch-ruby'
gem 'rack'
gem 'clearance'
gem 'knock'
gem 'simple_form', '>= 3.5.1'
gem 'pundit'
gem 'premailer-rails'
gem 'paper_trail'
gem 'blazer'
gem 'friendly_id'
gem 'stringex'
gem 'rollbar'
gem 'rack-cors', require: 'rack/cors'

# Image uploads
gem 'shrine'
gem 'image_processing'
gem 'mini_magick'
gem 'aws-sdk-s3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem 'debug', platforms: [:mri, :mingw, :x64_mingw]

  # Support #save_and_open_page in feature specs
  gem 'launchy'

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-performance', require: false

  # Automatically run the specs (like autotest)
  gem 'guard-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler'
  gem 'letter_opener'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'simplecov', require: false
  gem 'email_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

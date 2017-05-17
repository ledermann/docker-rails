Clearance.configure do |config|
  config.mailer_sender = ENV['APP_EMAIL']
  config.rotate_csrf_on_sign_in = true
end

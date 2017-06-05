class ApplicationMailer < ActionMailer::Base
  default from: ENV['APP_EMAIL']
  layout 'mailer'
end

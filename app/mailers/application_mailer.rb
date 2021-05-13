class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.app_email
  layout 'mailer'
end

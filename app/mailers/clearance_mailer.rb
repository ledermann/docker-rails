class ClearanceMailer < ApplicationMailer
  def change_password(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(
        'clearance.models.clearance_mailer.change_password'
      )
    )
  end

  def registration_confirmation(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(
        'clearance.models.clearance_mailer.registration_confirmation'
      )
    )
  end
end

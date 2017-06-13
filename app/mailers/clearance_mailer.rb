class ClearanceMailer < ApplicationMailer
  def change_password(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(
        :change_password,
        scope: [:clearance, :models, :clearance_mailer]
      )
    )
  end

  def registration_confirmation(user)
    @user = user
    mail(
      to: @user.email,
      subject: I18n.t(
        :registration_confirmation,
        scope: [:clearance, :models, :clearance_mailer]
      )
    )
  end
end

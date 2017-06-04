class ClearanceMailerPreview < ActionMailer::Preview
  def change_password
    user = User.new(
      id: 1234,
      email: 'john@example.com',
      confirmation_token: Clearance::Token.new
    )

    ClearanceMailer.change_password(user)
  end

  def registration_confirmation
    user = User.new(
      id: 1234,
      email: 'john@example.com',
      email_confirmation_token: Clearance::Token.new
    )

    ClearanceMailer.registration_confirmation(user)
  end
end

class ClearanceMailerPreview < ActionMailer::Preview

  def change_password
    user = User.new(
      id: 1234,
      email: 'john@example.com',
      confirmation_token: Clearance::Token.new
    )

    ClearanceMailer.change_password(user)
  end

end

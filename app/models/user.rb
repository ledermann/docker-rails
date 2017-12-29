class User < ApplicationRecord
  include Clearance::User

  has_many :audits, foreign_key: 'whodunnit', dependent: :nullify, inverse_of: :user

  def confirmed?
    email_confirmed_at.present?
  end

  def confirm!
    update_attributes email_confirmed_at: Time.current,
                      email_confirmation_token: nil
  end

  def confirm_with_token(token)
    confirm! if token == email_confirmation_token
  end
end

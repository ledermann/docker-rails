class User < ApplicationRecord
  has_many :audits, foreign_key: 'whodunnit', dependent: :nullify, inverse_of: :user

  ######################################
  ## Clearance
  include Clearance::User

  def confirmed?
    email_confirmed_at.present?
  end

  def confirm!
    update! email_confirmed_at: Time.current,
            email_confirmation_token: nil
  end

  def confirm_with_token(token)
    confirm! if token == email_confirmation_token
  end

  ######################################
  # Knock
  def to_token_payload
    {
      sub: id,
      admin: is_admin,
      email:
    }
  end

  # Knock expects #authenticate, but Clearance adds #authenticated?
  alias authenticate authenticated?
end

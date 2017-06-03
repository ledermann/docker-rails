require 'rails_helper'

describe ClearanceMailer do
  let(:user) { create :user, email: 'john.doe@example.com', confirmation_token: Clearance::Token.new }

  describe '#change_password' do
    subject(:email) { ClearanceMailer.change_password(user) }

    it { expect(email).to be_delivered_to 'john.doe@example.com' }
    it { expect(email).to be_delivered_from 'reply@example.org' }
    it { expect(email).to have_subject 'Change your password' }
    it { expect(email).to have_body_text 'Someone, hopefully you, requested we send you a link to change your password' }
    it { expect(email).to have_body_text edit_user_password_url(user, token: user.confirmation_token) }
  end
end

require 'rails_helper'

describe 'error handling' do
  scenario 'not existing path' do
    expect(Rails.logger).to receive(:warn).with(/Path not found/)

    visit '/not-existing-path'

    expect(page).to have_text("The page you were looking for doesn't exist")
    expect(page.status_code).to eq 404
  end
end

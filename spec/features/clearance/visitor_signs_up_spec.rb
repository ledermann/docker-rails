require "rails_helper"

feature "Visitor signs up" do
  scenario "by navigating to the page" do
    visit sign_in_path

    click_link I18n.t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password and confirmation" do
    sign_up_with "valid@example.com", "password"
    expect(page).to have_content I18n.t("flashes.confirmation_requested")

    open_email "valid@example.com"
    click_first_link_in_email

    expect(page).to have_content I18n.t("flashes.confirmed_registration")
  end

  scenario "tries with invalid email" do
    sign_up_with "invalid_email", "password"

    expect_user_to_be_signed_out
  end

  scenario "tries with blank password" do
    sign_up_with "valid@example.com", ""

    expect_user_to_be_signed_out
  end
end

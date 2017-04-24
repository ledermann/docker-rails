require 'rails_helper'

feature 'Pages', :js => true do
  let!(:example_page) { Page.create!(title: 'Name', content: 'foo') }

  it 'loads single page on row click' do
    visit pages_path

    expect(page).to have_xpath('.//table/tbody/tr')
    page.find(:xpath, ".//table/tbody/tr/td[1]").click

    expect(page.current_path).to eq("/pages/#{example_page.id}")
  end
end

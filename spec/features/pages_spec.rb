require 'rails_helper'

feature 'Page management' do
  before :each do
    30.times { create(:page) }
  end

  let!(:example_page) { create(:page, :reindex, title: 'Example') }

  scenario 'User navigates through pages', js: true do
    visit pages_path

    expect(page).to have_selector('h1', text: 'Pages')
    expect(page).to have_xpath('.//table/tbody/tr', count: 25)
    expect(page).to have_link(href: edit_page_path(example_page))
    expect(page).to have_link('Add new Page', href: new_page_path)

    # Scroll down to load whole list via infinite scrolling
    page.execute_script "window.scrollBy(0, $(window).height())"
    expect(page).to have_xpath('.//table/tbody/tr', count: 31)

    # Scroll up again and go to single page by clicking on a row
    page.execute_script "window.scrollTo(0, 0)"
    find(:xpath, ".//table/tbody/tr[1]").click
    expect(page.current_path).to eq(page_path(example_page))

    # Go to home page by clicking an the navbar logo
    find(:xpath, './/a[contains(@class, "navbar-brand")]').click
    expect(page.current_path).to eq(root_path)
  end

  scenario 'User searches for a page' do
    visit pages_path
    expect(page).to_not have_text('Pages matching')

    within '#search' do
      fill_in 'q', with: 'Exam'
    end
    click_on 'Search for Text'

    expect(page).to have_text('Pages matching')
    expect(page).to have_current_path(/q=Exam/)
    expect(page).to have_xpath('.//table/tbody/tr', count: 1)
    expect(page).to have_link(href: page_path(example_page))
  end

  scenario 'User opens a single page', js: true do
    visit page_path(example_page)

    expect(page).to have_selector('h1', text: 'Example')
    expect(page).to have_selector('time', text: 'ago')
    expect(page).to have_link(href: edit_page_path(example_page), text: 'Edit Page')
  end

  scenario 'User edits an existing page' do
    visit edit_page_path(example_page)

    expect(page).to have_selector('h1', text: 'Editing Page')
    expect(page).to have_button('Update Page')

    fill_in 'page[title]', with: 'Bar'
    fill_in 'page[content]', with: 'dolor sit amet'
    click_on 'Update Page'

    expect(page.current_path).to eq(page_path(example_page))
    expect(page).to have_text 'Page was successfully updated.'
    expect(page).to have_selector('h1', text: 'Bar')
    expect(page).to have_selector('p', text: 'dolor sit amet')
  end

  scenario 'User deletes an existing page', js: true do
    visit pages_path

    expect(page).to have_selector('h1', text: 'Pages')
    expect(page).to have_selector('td', text: 'Example')

    page.accept_alert 'Are you sure?' do
      find(:xpath, '//table/tbody/tr[1]//a[@title="Destroy"]').click
    end

    expect(page.current_path).to eq(pages_path)
    expect(page).to have_text 'Page was successfully destroyed.'
    expect(page).to_not have_selector('td', text: 'Example')
  end

  scenario 'User creates a new page', js: true do
    visit pages_path

    click_on 'Add new Page'

    expect(page.current_path).to eq(new_page_path)
    expect(page).to have_selector('h1', text: 'New Page')
    expect(page).to have_button('Create Page')

    fill_in 'page[title]', with: 'Bar'
    click_on 'Create Page'
    expect(page).to have_selector('div.form-group.has-error')
    fill_in 'page[content]', with: 'dolor sit amet'
    expect(page).to_not have_selector('div.form-group.has-error')
    click_on 'Create Page'

    expect(page).to have_text 'Page was successfully created.'
    expect(page).to have_selector('h1', text: 'Bar')
    expect(page).to have_selector('p', text: 'dolor sit amet')
  end
end

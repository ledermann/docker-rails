require 'rails_helper'

describe 'Post management' do
  before :each do
    30.times { create(:post) }
    Post.search_index.delete
    Post.reindex
  end

  let!(:example_post) { create(:post, :reindex, title: 'Example', content: '<p>Lorem ipsum</p>') }

  context "User who is not an admin" do
    scenario 'navigates through posts', js: true do
      visit posts_path

      expect(page).to have_selector('h1', text: 'Example application')
      expect(page).to have_css('table tbody tr', count: 25)
      expect(page).to have_selector('#post-count', text: '31 Posts')
      expect(page).to_not have_link('', href: new_post_path)

      # Scroll down to load whole list via infinite scrolling
      scroll_to_bottom
      expect(page).to have_css('table tbody tr', count: 31, wait: 5)

      # Scroll up again and go to single post by clicking on a row
      scroll_to_top
      first('table tbody tr').click
      expect(page).to have_current_path(post_path(example_post))

      # Go to homepage by clicking an the navbar logo
      find('a.navbar-brand').click
      expect(page).to have_current_path(root_path)
    end

    scenario 'searches for a post with autocompletion', js: true do
      visit posts_path

      within '#search' do
        fill_in 'q', with: 'Exa'
      end
      expect(page).to have_css('.autocomplete div', text: 'example')

      within '#search' do
        fill_in 'q', with: "Exam\n"
      end

      expect(page).to have_css('table tbody tr', count: 1, text: 'Example')
      expect(page).to have_selector('#post-count', text: '1 Post')
      expect(page).to have_current_path(/q=Exam/)
    end

    scenario 'searches for a post and sees suggestions' do
      visit posts_path(q: 'Exmple')

      expect(page).to have_selector('#post-suggestions', text: 'Did you mean example')
    end

    scenario 'opens a single page', js: true do
      visit post_path(example_post)

      expect(page).to have_selector('h1', text: 'Example')
      expect(page).to have_selector('time', text: 'ago')
      expect(page).to have_link(href: edit_post_path(example_post))
    end

    scenario 'sees auto-refreshed post (via ActionCable) if other user updates it', js: true do
      Capybara.using_session(:first_user) do
        visit post_path(example_post)

        expect(page).to have_selector('h1', text: 'Example')
        expect(page).to have_selector('p', text: 'Lorem ipsum')
      end

      Capybara.using_session(:second_user) do
        visit edit_post_path(example_post, as: create(:admin))

        all(:css, "trix-editor").first.click.set('dolor sit amet')

        click_on 'Update Post'
      end

      Capybara.using_session(:first_user) do
        expect(page).to have_selector('div', text: 'dolor sit amet')
      end
    end

    scenario "is not allowed to edit a page" do
      visit edit_post_path(example_post)
      expect(page).to have_selector('p.alert', text: 'not authorized')
    end

    scenario 'is not allowed to delete a page', js: true do
      visit post_path(example_post)

      page.accept_alert do
        find('a[data-original-title="Delete Post"]').click
      end

      expect(page).to have_selector('p.alert', text: 'not authorized')
    end

    scenario 'is not allowed to create a new page', js: true do
      visit new_post_path

      expect(page).to have_selector('p.alert', text: 'not authorized')
    end
  end

  context "User who is an admin" do
    scenario 'edits an existing page', js: true do
      visit edit_post_path(example_post, as: create(:admin))

      expect(page).to have_selector('h1', text: 'Editing Post')
      expect(page).to have_button('Update Post')

      fill_in 'post[title]', with: 'Bar'
      all(:css, "trix-editor").first.click.set('dolor sit amet')
      click_on 'Update Post'

      expect(page).to have_text 'Post was successfully updated.'
      expect(page).to have_selector('h1', text: 'Bar')
      expect(page).to have_selector('div', text: 'dolor sit amet')
      expect(page).to have_current_path(post_path(example_post.reload))
    end

    scenario 'deletes an existing page', js: true do
      visit post_path(example_post, as: create(:admin))

      page.accept_confirm do
        find('a[data-original-title="Delete Post"]').click
      end

      expect(page).to have_text 'Post was successfully destroyed.'
      expect(page).to_not have_selector('td', text: 'Example')
      expect(page).to have_current_path(posts_path)
    end

    scenario 'creates a new page', js: true do
      visit posts_path(as: create(:admin))

      click_on 'add-new-post'

      expect(page).to have_selector('h1', text: 'New Post')
      expect(page).to have_button('Create Post')
      expect(page).to have_current_path(new_post_path)

      fill_in 'post[title]', with: 'Bar'
      all(:css, "trix-editor").first.click.set('dolor sit amet')
      click_on 'Create Post'

      expect(page).to have_text 'Post was successfully created.'
      expect(page).to have_selector('h1', text: 'Bar')
      expect(page).to have_selector('div', text: 'dolor sit amet')
    end

    scenario 'creates a new page with image upload'

    scenario 'creates a new page with client side validation', js: true do
      visit new_post_path(as: create(:admin))

      click_on 'Create Post'

      expect(page).to have_selector('.post_title.has-danger')

      fill_in 'post[title]', with: 'Foo'
      expect(page).to_not have_selector('.post_title.has-danger')

      all(:css, "trix-editor").first.click.set('dolor sit amet')
      click_on 'Create Post'

      expect(page).to have_text 'Post was successfully created.'
    end
  end
end

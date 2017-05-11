require 'rails_helper'

describe 'pages/edit' do
  before :each do
    @page = assign(:page, create(:page))
  end

  it 'renders the edit page form' do
    render

    assert_select 'form[action=?][method=?]', page_path(@page), 'post' do
      assert_select 'input[name=?]', 'page[title]'
      assert_select 'textarea[name=?]', 'page[content]'
    end
  end
end

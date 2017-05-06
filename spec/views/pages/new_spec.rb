require 'rails_helper'

describe 'pages/new' do
  before:each do
    assign(:page, Page.new(
      title: 'MyString'
    ))
  end

  it 'renders new page form' do
    render

    assert_select 'form[action=?][method=?]', pages_path, 'post' do
      assert_select 'input#page_title[name=?]', 'page[title]'
    end
  end
end

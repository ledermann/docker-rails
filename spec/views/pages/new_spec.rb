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
      assert_select 'input[name=?]', 'page[title]'
      assert_select 'textarea[name=?]', 'page[content]'
    end
  end
end

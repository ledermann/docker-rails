require 'rails_helper'

describe 'pages/show' do
  before :each do
    @page = assign(:page, Page.create!(
      title: 'FooBar',
      content: 'Lorem ipsum'
    ))
  end

  it 'renders attributes' do
    render

    assert_select 'h1', 'FooBar'
    assert_select 'p', 'Lorem ipsum'
  end
end

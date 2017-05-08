require 'rails_helper'

describe 'pages/show' do
  before :each do
    @page = assign(:page, create(:page))
  end

  it 'renders attributes' do
    render

    assert_select 'h1', 'Foo'
    assert_select 'p', 'Lorem ipsum'
  end
end

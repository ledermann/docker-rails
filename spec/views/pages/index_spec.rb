require 'rails_helper'

describe 'pages/index' do
  before :each do
    assign :pages, [
      create(:page),
      create(:page)
    ]
  end

  it 'renders a list of pages' do
    render
    assert_select 'tr > td', :text => 'Foo', :count => 2
  end
end

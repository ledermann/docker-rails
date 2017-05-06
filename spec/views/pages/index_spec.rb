require 'rails_helper'

describe 'pages/index' do
  before :each do
    assign :pages, [
      Page.create!(
        title:   'Name',
        content: 'foo1'
      ),
      Page.create!(
        title:   'Name',
        content: 'foo2'
      )
    ]
  end

  it 'renders a list of pages' do
    render
    assert_select 'tr > td', :text => 'Name', :count => 2
  end
end

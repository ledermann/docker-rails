require 'rails_helper'

describe 'posts/show' do
  before :each do
    @post = assign(:post, create(:post, title: 'Foo'))
  end

  it 'renders attributes' do
    render

    assert_select 'h1', 'Foo'
    assert_select 'p', 'Lorem ipsum'
  end
end

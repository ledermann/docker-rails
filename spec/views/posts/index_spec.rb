require 'rails_helper'

describe 'posts/index' do
  before :each do
    2.times { create(:post, title: 'Foo') }
    assign :posts, Post.all.page(1)
  end

  it 'renders a list of posts' do
    render
    assert_select 'tr > td', text: 'Foo', count: 2
  end
end

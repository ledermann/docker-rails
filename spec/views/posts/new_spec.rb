require 'rails_helper'

describe 'posts/new' do
  before :each do
    assign(:post, Post.new(title: 'MyString'))
  end

  it 'renders new post form' do
    render

    assert_select 'form[action=?][method=?]', posts_path, 'post' do
      assert_select 'input[name=?]', 'post[title]'
      assert_select 'input[name=?]', 'post[content]'
      assert_select 'trix-editor[input=?]', 'post_content'
    end
  end
end

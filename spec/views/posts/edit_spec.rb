require 'rails_helper'

describe 'posts/edit' do
  before :each do
    @post = assign(:post, create(:post))
  end

  it 'renders the edit post form' do
    render

    assert_select 'form[action=?][method=?]', post_path(@post), 'post' do
      assert_select 'input[name=?]', 'post[title]'
      assert_select 'input[name=?]', 'post[content]'
      assert_select 'trix-editor[input=?]', 'post_content'
    end
  end
end

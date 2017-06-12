require 'rails_helper'

describe PostsHelper do
  let(:post) { Post.new content: 'This is **strong**' }

  describe "#content_as_html" do
    it "renders HTML" do
      expect(helper.content_as_html(post)).to eq("<p>This is <strong>strong</strong></p>\n")
    end
  end

  describe "#content_as_plaintext" do
    it "removes all tags" do
      expect(helper.content_as_plaintext(post)).to eq("This is strong\n")
    end
  end
end

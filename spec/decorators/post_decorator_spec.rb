require 'rails_helper'

describe PostDecorator do
  let(:post) { Post.new(content: 'This is **strong**') }
  subject { post.extend PostDecorator }

  describe "#content_as_html" do
    it "renders HTML" do
      expect(subject.content_as_html).to eq("<p>This is <strong>strong</strong></p>\n")
    end
  end

  describe "#content_as_plaintext" do
    it "removes all tags" do
      expect(subject.content_as_plaintext).to eq("This is strong\n")
    end
  end
end

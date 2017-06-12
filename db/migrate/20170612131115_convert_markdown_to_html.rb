class ConvertMarkdownToHtml < ActiveRecord::Migration[5.1]
  def up
    Post.find_each do |post|
      content_as_html = Kramdown::Document.new(post.content).to_html

      post.update_attributes! content: content_as_html
    end
  end
end

module PostsHelper
  def content_as_html(post)
    Kramdown::Document.new(post.content).to_html
  end

  def content_as_plaintext(post)
    strip_tags(content_as_html(post))
  end
end

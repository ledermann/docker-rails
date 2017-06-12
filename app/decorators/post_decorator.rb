module PostDecorator
  def content_as_html
    Kramdown::Document.new(content).to_html
  end

  def content_as_plaintext
    full_sanitizer = Rails::Html::FullSanitizer.new
    full_sanitizer.sanitize(content_as_html)
  end
end

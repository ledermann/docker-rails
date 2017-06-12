class Post < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  validates :title, presence: true
  validates :content, presence: true

  def content_as_plaintext
    @content_as_plaintext ||= begin
      full_sanitizer = Rails::Html::FullSanitizer.new
      full_sanitizer.sanitize(content)
    end
  end

  searchkick word_start: [ :title, :content, :combined ],
             highlight:  [ :title, :content ],
             callbacks:  :async

  def search_data
    {
      title:    title,
      content:  content_as_plaintext,
      combined: "#{title} #{content_as_plaintext}"
    }
  end

  def self.elasticsearch(query, options = {})
    search query, {
      fields:       [ 'title^10', 'content', 'combined' ],
      highlight:    true,
      match:        :word_start,
      misspellings: { prefix_length: 2 }
    }.merge(options)
  end

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

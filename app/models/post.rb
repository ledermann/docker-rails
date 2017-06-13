class Post < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  validates :title, presence: true
  validates :content, presence: true

  def content_as_plaintext
    @content_as_plaintext ||= begin
      # Get text, dont just strip tags. This preserves spaces
      # Based on https://stackoverflow.com/a/28449868/57950
      Nokogiri::HTML(content).xpath('//text()').map(&:text).map(&:strip).join(' ')
    end
  end

  searchkick word_start: [ :title, :content, :combined ],
             highlight:  [ :title, :content ],
             suggest:    [ :title, :content ],
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
      suggest:      true,
      misspellings: false
    }.merge(options)
  end

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

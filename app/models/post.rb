class Post < ApplicationRecord
  validates_presence_of :title, :content

  searchkick word_start: [ :title, :content, :combined ],
             highlight:  [ :title, :content ],
             callbacks:  :async

  def search_data
    { title:    title,
      content:  content,
      combined: "#{title} #{content}"
    }
  end

  def self.elasticsearch(query, options={})
    search query, {
             fields:       [ 'title^10', 'content', 'combined' ],
             highlight:    true,
             match:        :word_start,
             misspellings: { prefix_length: 2 },
           }.merge(options)
  end

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

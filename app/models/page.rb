class Page < ApplicationRecord
  validates_presence_of :title, :content
  searchkick callbacks: :async,
             highlight: [:title, :content]

  after_commit on: :update do |page|
    PageRelayJob.perform_later(page)
  end
end

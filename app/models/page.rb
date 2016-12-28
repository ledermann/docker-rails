class Page < ApplicationRecord
  validates_presence_of :title, :content
  searchkick callbacks: :async

  after_commit on: :update do |page|
    PageRelayJob.perform_later(page)
  end
end

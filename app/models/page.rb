class Page < ApplicationRecord
  validates_presence_of :title, :content
  searchkick callbacks: :async

  after_commit { PageRelayJob.perform_later(self) }
end

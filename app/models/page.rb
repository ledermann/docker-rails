class Page < ApplicationRecord
  validates_presence_of :title, :content

  searchkick word_start: [ :title, :content ],
             highlight:  [ :title, :content ],
             callbacks:  :async

  after_commit on: :update do |page|
    PageRelayJob.perform_later(page)
  end
end

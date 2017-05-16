class Post < ApplicationRecord
  validates_presence_of :title, :content

  searchkick word_start: [ :title, :content ],
             highlight:  [ :title, :content ],
             callbacks:  :async

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

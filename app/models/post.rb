class Post < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include PostSearch

  validates :title, presence: true
  validates :content, presence: true

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

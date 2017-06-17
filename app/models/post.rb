class Post < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include PostSearch
  has_paper_trail class_name: 'Audit', versions: :audits

  validates :title, presence: true
  validates :content, presence: true

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end
end

class Post < ApplicationRecord
  include PostSearch
  has_paper_trail class_name: 'Audit',
                  versions:   :audits,
                  skip:       [ :created_at, :updated_at ]

  validates :title, presence: true
  validates :content, presence: true

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end

  has_many :clips, dependent: :destroy, inverse_of: :post
  accepts_nested_attributes_for :clips, allow_destroy: true
end

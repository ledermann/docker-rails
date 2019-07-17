class Post < ApplicationRecord
  include PostSearch
  has_paper_trail versions: { name: :audits, class_name: 'Audit' },
                  skip:     [ :created_at, :updated_at ]

  extend FriendlyId
  friendly_id :title

  validates :title, presence: true
  validates :content, presence: true

  after_commit on: :update do |post|
    PostRelayJob.perform_later(post)
  end

  has_many :clips, -> { order(:id) }, dependent: :destroy, inverse_of: :post
  accepts_nested_attributes_for :clips, allow_destroy: true
end

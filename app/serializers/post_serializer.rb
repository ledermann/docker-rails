class PostSerializer < Panko::Serializer
  attributes :id, :slug, :created_at, :updated_at, :clips_count, :title, :content, :copyright

  has_many :clips
end

class PostPreviewSerializer < ActiveModel::Serializer
  attributes :id, :slug, :updated_at, :clips_count, :title, :content

  def title
    if instance_options[:search_string] && object.search_highlights[:title]
      object.search_highlights[:title]
    else
      object.title
    end
  end

  def content
    if instance_options[:search_string] && object.search_highlights[:content]
      "…#{object.search_highlights[:content]}…"
    else
      object.content_as_plaintext.truncate(300)
    end
  end
end

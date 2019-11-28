class PostPreviewSerializer < Panko::Serializer
  attributes :id, :slug, :updated_at, :clips_count, :title, :content

  def title
    if object.respond_to?(:search_highlights) && object.search_highlights[:title]
      object.search_highlights[:title]
    else
      object.title
    end
  end

  def content
    if object.respond_to?(:search_highlights) && object.search_highlights[:content]
      "…#{object.search_highlights[:content]}…"
    else
      object.content_as_plaintext.truncate(300)
    end
  end
end

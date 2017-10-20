json.array! @posts do |post|
  json.extract! post, :id, :created_at, :updated_at, :clips_count

  if search_string && post.search_highlights[:title]
    json.title post.search_highlights[:title]
  else
    json.title post.title
  end

  if search_string && post.search_highlights[:content]
    json.content "…#{post.search_highlights[:content]}…"
  else
    json.content post.content_as_plaintext.truncate(300)
  end

  json.url post_url(post, format: :json)
end

json.extract! @post, *@post.attributes.keys

json.clips @post.clips do |clip|
  json.id clip.id
  json.filename clip.image[:original].original_filename

  json.original do
    json.url clip.image_url(:original, expires_in: 1.day.to_i)
    json.size clip.image[:original].size
    json.mime_type clip.image[:original].mime_type
  end

  json.large do
    json.url clip.image_url(:large, expires_in: 1.day.to_i)
    json.size clip.image[:large].size
    json.mime_type clip.image[:large].mime_type
  end

  json.thumbnail do
    json.url clip.image_url(:thumbnail, expires_in: 1.day.to_i)
    json.size clip.image[:thumbnail].size
    json.mime_type clip.image[:thumbnail].mime_type
  end

end

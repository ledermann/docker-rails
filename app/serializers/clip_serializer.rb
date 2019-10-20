class ClipSerializer < Panko::Serializer
  attributes :id, :filename, :original, :large, :thumbnail

  def filename
    return unless object.image_stored?

    object.image.original_filename
  end

  def original
    return unless object.image_stored?

    {
      url:       object.image_url(expires_in: 1.day.to_i),
      size:      object.image.size,
      mime_type: object.image.mime_type
    }
  end

  def large
    return unless object.image_stored?

    {
      url:       object.image_url(:large, expires_in: 1.day.to_i),
      size:      object.image(:large).size,
      mime_type: object.image(:large).mime_type
    }
  end

  def thumbnail
    return unless object.image_stored?

    {
      url:       object.image_url(:thumbnail, expires_in: 1.day.to_i),
      size:      object.image(:thumbnail).size,
      mime_type: object.image(:thumbnail).mime_type
    }
  end
end

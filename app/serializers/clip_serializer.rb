class ClipSerializer < ActiveModel::Serializer
  attributes :id, :filename, :original, :large, :thumbnail

  def filename
    return unless image_processed?

    object.image[:original].original_filename
  end

  def original
    return unless image_processed?

    {
      url:       object.image_url(:thumbnail, expires_in: 1.day.to_i),
      size:      object.image[:thumbnail].size,
      mime_type: object.image[:thumbnail].mime_type
    }
  end

  def large
    return unless image_processed?

    {
      url:       object.image_url(:large, expires_in: 1.day.to_i),
      size:      object.image[:large].size,
      mime_type: object.image[:large].mime_type
    }
  end

  def thumbnail
    return unless image_processed?

    {
      url:       object.image_url(:thumbnail, expires_in: 1.day.to_i),
      size:      object.image[:thumbnail].size,
      mime_type: object.image[:thumbnail].mime_type
    }
  end

  def image_processed?
    object.image.is_a?(Hash)
  end
end

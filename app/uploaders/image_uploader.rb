require 'image_processing/mini_magick'

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :pretty_location
  plugin :validation_helpers
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io, _context|
    original = io.download

    large = ImageProcessing::MiniMagick.
            source(original).
            resize_to_limit(1200, 1200, &:auto_orient).
            call

    thumbnail = ImageProcessing::MiniMagick.
                source(original).
                resize_to_fill(400, 400, gravity: 'Center').
                call

    {
      original:  io,
      large:     large,
      thumbnail: thumbnail
    }
  end
end

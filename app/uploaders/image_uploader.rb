require 'image_processing/mini_magick'

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :pretty_location
  plugin :validation_helpers
  plugin :determine_mime_type
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
  end

  process(:store) do |io, _context|
    original  = io.download
    large     = resize_to_limit!(original, 1200, 1200, &:auto_orient)
    thumbnail = resize_to_fill(large, 400, 400, gravity: 'Center')

    {
      original:  io,
      large:     large,
      thumbnail: thumbnail
    }
  end
end

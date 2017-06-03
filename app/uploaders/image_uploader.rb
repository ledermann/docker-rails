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
    {
      original:  io,
      thumbnail: resize_to_limit!(io.download, 250, 250),
      panorama:  resize_to_fill!(io.download, 1200, 250, gravity: 'Center')
    }
  end
end

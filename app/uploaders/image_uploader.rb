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
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      versions[:large]     = pipeline.resize_to_limit!(1200, 1200, &:auto_orient)
      versions[:thumbnail] = pipeline.resize_to_fill!(400, 400, gravity: 'Center')
    end

    versions # return the hash of processed files
  end
end

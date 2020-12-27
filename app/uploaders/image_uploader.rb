require 'image_processing/mini_magick'

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :pretty_location
  plugin :validation_helpers

  Attacher.validate do
    validate_mime_type_inclusion(%w[image/jpeg image/png image/gif])
  end

  Attacher.derivatives_processor do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      large:     magick.resize_to_limit!(1200, 1200, &:auto_orient),
      thumbnail: magick.resize_to_fill!(400, 400, gravity: 'Center')
    }
  end
end

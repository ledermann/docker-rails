class Clip < ApplicationRecord
  belongs_to :post, counter_cache: true, touch: true

  include ImageUploader::Attachment.new(:image)

  def image_stored?
    image_attacher.stored?
  end
end

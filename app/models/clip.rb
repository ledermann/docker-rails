class Clip < ApplicationRecord
  belongs_to :post, counter_cache: true, touch: true

  include ImageUploader::Attachment.new(:image)
end

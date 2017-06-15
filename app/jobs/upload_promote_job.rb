class UploadPromoteJob < ApplicationJob
  queue_as :default

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end

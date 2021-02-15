require 'shrine'

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :upload_endpoint
Shrine.plugin :presign_endpoint
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type
Shrine.plugin :derivatives, versions_compatibility: true # handle versions column format

# Don't load when there is no APP_HOST (e.g. when precompiling assets)
return unless ENV['APP_HOST']

if Rails.env.test?
  require "shrine/storage/memory"

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  require 'shrine/storage/s3'

  # Allow self signed certificate (needed for Minio server)
  Aws.config[:ssl_verify_peer] = ENV.fetch('AWS_SSL_VERIFY_PEER', true) != 'false'

  s3_options = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_REGION'),
    bucket:            ENV.fetch('AWS_BUCKET'),
    endpoint:          ENV.fetch('AWS_ENDPOINT', 'https://s3.amazonaws.com'),
    force_path_style:  ENV.fetch('AWS_FORCE_PATH_STYLE', false)
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(**s3_options.merge(prefix: "#{Rails.env}/cache")),
    store: Shrine::Storage::S3.new(**s3_options.merge(prefix: "#{Rails.env}/store"))
  }
end

Shrine.plugin :backgrounding
Shrine::Attacher.promote_block do
  UploadPromoteJob.perform_later(self.class.name, record.class.name, record.id, name, file_data)
end
Shrine::Attacher.destroy_block do
  UploadDeleteJob.perform_later(self.class.name, data)
end

class Shrine
  class Attacher
    def promote(*)
      create_derivatives
      super
    end
  end
end

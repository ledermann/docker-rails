require 'shrine'

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :direct_upload
Shrine.plugin :restore_cached_data

# On precompile, the ENV vars for AWS are not set
return if ARGV.join.include?('assets:precompile')

if Rails.env.test?
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
else
  require 'shrine/storage/s3'

  s3_options = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_REGION'),
    bucket:            ENV.fetch('AWS_BUCKET')
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "#{Rails.env}/cache", **s3_options),
    store: Shrine::Storage::S3.new(prefix: "#{Rails.env}/store", **s3_options)
  }
end

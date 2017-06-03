# On precompile, the ENV vars for AWS are not set
return if ARGV.join.include?('assets:precompile')

require 'shrine'
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

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms

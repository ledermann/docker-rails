require 'fileutils'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
}

RSpec.configure do |config|
  config.before :suite do
    FileUtils.rm_r 'public/uploads'
  end
end

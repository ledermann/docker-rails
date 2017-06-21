require 'fileutils'

RSpec.configure do |config|
  config.before :suite do
    FileUtils.remove_dir('public/uploads', true)
  end
end

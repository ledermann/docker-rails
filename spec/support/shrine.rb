require 'fileutils'

RSpec.configure do |config|
  config.before :suite do
    FileUtils.rm_r 'public/uploads'
  end
end

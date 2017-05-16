RSpec.configure do |config|
  config.before :suite do
    Post.reindex
    Searchkick.disable_callbacks
  end

  config.around(:each, search: true) do |example|
    Searchkick.enable_callbacks
    example.run
    Searchkick.disable_callbacks
  end
end

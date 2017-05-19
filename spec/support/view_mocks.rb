RSpec.configure do |config|
  config.before :each, type: :view do
    without_partial_double_verification do
      allow(view).to receive(:title).and_return(nil)
      allow(view).to receive(:search_string).and_return(nil)
    end
  end
end

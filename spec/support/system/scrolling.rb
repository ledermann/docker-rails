module SystemTest
  module Scrolling
    def scroll_to_bottom
      page.execute_script 'window.scrollBy (0, document.body.scrollHeight)'
    end

    def scroll_to_top
      page.execute_script 'window.scrollTo (0, 0)'
    end
  end
end

RSpec.configure do |config|
  config.include SystemTest::Scrolling, type: :system
end

require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "creating" do
    page = Page.create! title: 'Foo', content: 'Lorem ipsum'

    Page.reindex
    assert_equal 1, Page.search("ipsum").total_count
  end
end

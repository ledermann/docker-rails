require 'rails_helper'

describe PageRelayJob do
  it 'should broadcast' do
    page = Page.create! title: 'Foo', content: 'Lorem ipsum'

    PageRelayJob.perform_now(page)

    # Currently, rspec-rails has no built-in support for testing ActionCable
    # https://github.com/rspec/rspec-rails/issues/1606
  end
end

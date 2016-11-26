require 'rails_helper'

describe Page do
  it 'can be searched' do
    page = Page.create! title: 'Foo', content: '1234567890'

    Page.reindex
    expect(Page.search('1234567890').total_count).to eq(1)
  end
end

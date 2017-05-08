require 'rails_helper'

describe Page do
  subject { create(:page, content: '1234567890') }

  it 'can be searched' do
    subject
    Page.reindex

    expect(Page.search('1234567890').total_count).to eq(1)
  end

  it 'enqueues PageRelayJob on update only' do
    expect {
      subject
    }.to_not have_enqueued_job(PageRelayJob)

    expect {
      subject.update_attributes! content: 'ipsum'
    }.to have_enqueued_job(PageRelayJob)

    expect {
      subject.destroy
    }.to_not have_enqueued_job(PageRelayJob)
  end
end

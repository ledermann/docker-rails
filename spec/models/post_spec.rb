require 'rails_helper'

describe Post do
  subject { create(:post, :reindex, content: '1234567890') }

  it 'can be searched' do
    subject

    expect(Post.search('1234567890').total_count).to eq(1)
  end

  it 'enqueues PostRelayJob on update only' do
    expect {
      subject
    }.to_not have_enqueued_job(PostRelayJob)

    expect {
      subject.update_attributes! content: 'ipsum'
    }.to have_enqueued_job(PostRelayJob)

    expect {
      subject.destroy
    }.to_not have_enqueued_job(PostRelayJob)
  end
end

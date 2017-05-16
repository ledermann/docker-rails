require 'rails_helper'

describe Post do
  subject { create(:post, :reindex, content: '1234567890') }

  it 'can be searched' do
    subject

    expect(Post.search('1234567890').total_count).to eq(1)
  end

  describe 'after_commit' do
    it "don't enqueues PostRelayJob on create" do
      expect(PostRelayJob).to_not receive(:perform_later)
      subject
    end

    it "enqueues PostRelayJob on create" do
      expect(PostRelayJob).to receive(:perform_later)
      subject.update_attributes! content: 'ipsum'
    end

    it "don't enqueues PostRelayJob on destroy" do
      expect(PostRelayJob).to_not receive(:perform_later)
      subject.destroy
    end
  end
end

require 'rails_helper'

describe Post do
  describe 'after_commit' do
    subject { create(:post) }

    it "performs PostRelayJob on update" do
      expect(PostRelayJob).to receive(:perform_later)
      subject.update! content: 'ipsum'
    end

    it "don't performs PostRelayJob on destroy" do
      expect(PostRelayJob).to_not receive(:perform_later)
      subject.destroy
    end

    it "don't performs PostRelayJob on create" do
      expect(PostRelayJob).to_not receive(:perform_later)
      subject
    end
  end

  describe "paper_trail" do
    subject { create(:post) }

    it "adds audits on create" do
      expect(subject.audits.count).to eq(1)
      expect(subject.audits.last.event).to eq('create')
    end

    it "adds version on update" do
      expect do
        subject.update! content: 'foo'
      end.to change(subject.audits, :count).by(1)
      expect(subject.audits.last.event).to eq('update')
    end

    it "adds version on destroy" do
      expect do
        subject.destroy
      end.to change(subject.audits, :count).by(1)
      expect(subject.audits.last.event).to eq('destroy')
    end
  end

  describe 'friendly_id' do
    subject(:post) { create :post, title: 'c++' }

    it 'creates slug from title' do
      expect(post.slug).to eq('c-plus-plus')
    end

    it 'updates slug if title changes' do
      post.update! title: 'c+++'
      expect(post.slug).to eq('c-plus-plus-plus')
    end
  end
end

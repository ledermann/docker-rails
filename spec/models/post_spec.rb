require 'rails_helper'

describe Post do
  describe 'after_commit' do
    subject { create(:post) }

    it "performs PostRelayJob on update" do
      expect(PostRelayJob).to receive(:perform_later)
      subject.update_attributes! content: 'ipsum'
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
      expect {
        subject.update_attributes! content: 'foo'
      }.to change(subject.audits, :count).by(1)
      expect(subject.audits.last.event).to eq('update')
    end

    it "adds version on destroy" do
      expect {
        subject.destroy
      }.to change(subject.audits, :count).by(1)
      expect(subject.audits.last.event).to eq('destroy')
    end
  end
end

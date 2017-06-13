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
end

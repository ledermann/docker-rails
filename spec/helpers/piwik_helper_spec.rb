require 'rails_helper'

describe PiwikHelper do
  describe 'piwik_meta_tags' do
    subject { helper.piwik_meta_tags }

    context "with env vars defined" do
      before do
        allow(Rails.configuration.x).to receive(:piwik_host).and_return("piwik.example.org")
        allow(Rails.configuration.x).to receive(:piwik_id).and_return("42")
      end

      it { expect(subject.lines.first.chomp).to  eq('<meta name="piwik-host" content="piwik.example.org">') }
      it { expect(subject.lines.second.chomp).to eq('<meta name="piwik-id" content="42">') }
    end

    context "without env vars" do
      it { expect(subject).to eq(nil) }
    end
  end
end

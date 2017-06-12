require 'rails_helper'

describe Post do
  describe 'content_as_plaintext' do
    let(:post) { Post.new(content: 'This is <strong>bold</strong><ul><li>One</li><li>Two</li></ul>') }

    describe "#content_as_plaintext" do
      it "removes all tags" do
        expect(post.content_as_plaintext).to eq("This is bold One Two")
      end
    end
  end

  describe 'searching' do
    let!(:post_single) do
      create :post,
             :reindex,
             title:   'Single Responsibility',
             content: 'Every module or class should have responsibility over a single part
                       of the functionality provided by the software, and that responsibility
                       should be entirely encapsulated by the class. All its services should be
                       narrowly aligned with that responsibility.'
    end

    let!(:post_demeter) do
      create :post,
             :reindex,
             title:   'The Law of Demeter',
             content: 'Each unit should have only limited knowledge about other units.'
    end

    let!(:post_reuse) do
      create :post,
             :reindex,
             title:   'Code reuse',
             content: 'Use of existing software, or software knowledge, to build new software,
                       following the reusability principles.'
    end

    context 'exact match' do
      it 'find posts by matching title' do
        expect(Post.elasticsearch('Responsibility').to_a).to eq([post_single])
        expect(Post.elasticsearch('Demeter').to_a).to eq([post_demeter])
        expect(Post.elasticsearch('reuse').to_a).to eq([post_reuse])

        expect(Post.elasticsearch('Single Responsibility').to_a).to eq([post_single])
        expect(Post.elasticsearch('Law Demeter').to_a).to eq([post_demeter])
        expect(Post.elasticsearch('Code reuse').to_a).to eq([post_reuse])
      end

      it 'find posts by matching content' do
        expect(Post.elasticsearch('responsibility single part').to_a).to eq([post_single])
        expect(Post.elasticsearch('limited knowledge other').to_a).to eq([post_demeter])
        expect(Post.elasticsearch('existing software').to_a).to eq([post_reuse])

        expect(Post.elasticsearch('encapsulated').to_a).to eq([post_single])
        expect(Post.elasticsearch('knowledge').to_a).to eq([post_demeter, post_reuse])
        expect(Post.elasticsearch('existing').to_a).to eq([post_reuse])
        expect(Post.elasticsearch('software').to_a).to eq([post_reuse, post_single])
      end
    end

    context 'Misspellings' do
      it "Ignores spelling errors after the second char" do
        expect(Post.elasticsearch('ResponsiXility').to_a).to eq([post_single])
        expect(Post.elasticsearch('RespXnsibility').to_a).to eq([post_single])
        expect(Post.elasticsearch('ReXponsibility').to_a).to eq([post_single])
      end

      it "Fails on spelling errors in the first two chars" do
        expect(Post.elasticsearch('RXsponsbility').to_a).to eq([])
        expect(Post.elasticsearch('Xesponsbility').to_a).to eq([])
      end
    end

    context 'Boosting' do
      it "prefers matches in title" do
        expect(Post.elasticsearch('the').to_a).to eq([post_demeter, post_single, post_reuse])
      end
    end

    context "Cross field matches" do
      it "find matches in both fields" do
        expect(Post.elasticsearch('Law knowledge').to_a).to eq([post_demeter])
      end
    end
  end

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

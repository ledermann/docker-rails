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
        expect(Post.search_for('Responsibility').to_a).to eq([post_single])
        expect(Post.search_for('Demeter').to_a).to eq([post_demeter])
        expect(Post.search_for('reuse').to_a).to eq([post_reuse])

        expect(Post.search_for('Single Responsibility').to_a).to eq([post_single])
        expect(Post.search_for('Law Demeter').to_a).to eq([post_demeter])
        expect(Post.search_for('Code reuse').to_a).to eq([post_reuse])
      end

      it 'find posts by matching content' do
        expect(Post.search_for('responsibility single part').to_a).to eq([post_single])
        expect(Post.search_for('limited knowledge other').to_a).to eq([post_demeter])
        expect(Post.search_for('existing software').to_a).to eq([post_reuse])

        expect(Post.search_for('encapsulated').to_a).to eq([post_single])
        expect(Post.search_for('knowledge').to_a).to eq([post_demeter, post_reuse])
        expect(Post.search_for('existing').to_a).to eq([post_reuse])
        expect(Post.search_for('software').to_a).to eq([post_reuse, post_single])
      end
    end

    context 'Misspellings' do
      def search(query)
        Post.search_for(query, misspellings: { prefix_length: 2 })
      end

      it "Ignores spelling errors after the second char" do
        expect(search('ResponsiXility').to_a).to eq([post_single])
        expect(search('RespXnsibility').to_a).to eq([post_single])
        expect(search('ReXponsibility').to_a).to eq([post_single])
      end

      it "Fails on spelling errors in the first two chars" do
        expect(search('RXsponsbility').to_a).to eq([])
        expect(search('Xesponsbility').to_a).to eq([])
      end

      it 'offers suggestions' do
        expect(search('ResponsiXility').suggestions).to eq(['responsibility'])
      end
    end

    context 'Boosting' do
      it "prefers matches in title" do
        expect(Post.search_for('the').to_a).to eq([post_demeter, post_single, post_reuse])
      end
    end

    context "Cross field matches" do
      it "find matches in both fields" do
        expect(Post.search_for('Law knowledge').to_a).to eq([post_demeter])
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

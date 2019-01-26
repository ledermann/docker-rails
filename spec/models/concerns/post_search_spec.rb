require 'rails_helper'

describe PostSearch do
  before { Post.reindex }

  describe '#content_as_plaintext' do
    let(:html) { '<style type="text/css">body { margin: 10px; }</style> This is <strong>bold</strong><ul><li>One</li><li>Two</li></ul>' }
    let(:post) { Post.new content: html }

    describe "#content_as_plaintext" do
      it "removes all tags" do
        expect(post.content_as_plaintext).to eq("This is bold One Two")
      end
    end
  end

  describe '.search_for' do
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

  describe '.autocomplete' do
    let!(:post_single) do
      create :post,
             :reindex,
             title:   'PL360',
             content: 'PL360 (or PL/360) is a programming language designed by Niklaus Wirth
                       and written by Niklaus Wirth, Joseph W. Wells, Jr., and Edwin
                       Satterthwaite, Jr. for the IBM System/360 computer at Stanford University.
                       A description of PL360 was published in early 1968, although the
                       implementation was probably completed before Wirth left Stanford in 1967.'
    end

    it "completes single word fragment" do
      expect(Post.autocomplete('nikl')).to eq(%w[niklaus])
      expect(Post.autocomplete('stan')).to eq(%w[stanford])
      expect(Post.autocomplete('unive')).to eq(%w[university])

      expect(Post.autocomplete('comp')).to eq(%w[computer completed])
    end

    it "completes words fragment" do
      expect(Post.autocomplete('niklaus wi')).to eq(['niklaus wirth', 'wirth'])
      expect(Post.autocomplete('niklaus wir')).to eq(['niklaus wirth', 'wirth'])
      expect(Post.autocomplete('niklau wir')).to eq(['niklaus wirth', 'wirth'])
    end

    it "corrects misspellings" do
      expect(Post.autocomplete('nikolaus wi')).to eq(['niklaus wirth', 'wirth'])
      expect(Post.autocomplete('wirtt')).to eq(['wirth'])
      expect(Post.autocomplete('implemntation')).to eq(['implementation'])

      # Don't correct if the first 2 chars don't match
      expect(Post.autocomplete('mplemntation')).to eq([])
      expect(Post.autocomplete('inplemntation')).to eq([])
    end
  end
end

require 'rails_helper'

describe ImageUploader do
  let(:post) { create :post }
  let(:clip) { create :clip, post: }

  before { clip.reload }

  it 'generates image_derivatives' do
    expect(clip.image_derivatives.keys).to match_array([:large, :thumbnail])
  end

  it 'stores image' do
    expect(clip.image.storage_key).to eq(:store)
    expect(clip.image(:large).storage_key).to eq(:store)
    expect(clip.image(:thumbnail).storage_key).to eq(:store)
  end

  describe "metadata" do
    subject { clip.image }

    it 'extracts mime type' do
      expect(subject.mime_type).to eq('image/jpeg')
    end

    it "extracts filesize" do
      expect(subject.size).to eq(8826)
    end

    it "extracts original filename" do
      expect(subject.original_filename).to eq('example.jpg')
    end

    it "extracts extension" do
      expect(subject.extension).to eq('jpg')
    end
  end

  it 'rejects other files than images' do
    clip = post.clips.build image: Rack::Test::UploadedFile.new('spec/fixtures/example.txt', 'text/plain')

    clip.valid?
    expect(clip.errors[:image]).to eq ['type must be one of: image/jpeg, image/png, image/gif']
  end
end

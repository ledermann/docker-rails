require 'rails_helper'

describe ImageUploader do
  let(:post) { create :post }
  let(:clip) { post.clips.create image: fixture_file_upload('spec/fixtures/example.jpg') }

  it 'generates image versions' do
    expect(clip.reload.image.keys).to eq([:original, :thumbnail])
  end

  it 'stores image' do
    expect(clip.reload.image[:original].storage_key).to eq('store')
  end

  it 'stores mime type' do
    expect(clip.reload.image[:original].mime_type).to eq('image/jpeg')
  end

  it 'rejects other files than images' do
    clip = post.clips.build image: fixture_file_upload('spec/fixtures/example.txt')

    clip.valid?
    expect(clip.errors[:image]).to eq ["isn't of allowed type (allowed types: image/jpeg, image/png, image/gif)"]
  end
end

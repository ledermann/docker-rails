require 'rails_helper'

describe ImageUploader do
  let(:post) { create :post, image: fixture_file_upload('spec/fixtures/example.jpg') }

  it 'generates image versions' do
    expect(post.reload.image.keys).to eq([:original, :thumbnail, :panorama])
  end

  it 'stores image' do
    expect(post.reload.image[:original].storage_key).to eq('store')
  end

  it 'stores mime type' do
    expect(post.reload.image[:original].mime_type).to eq('image/jpeg')
  end

  it 'rejects other files than images' do
    post = build :post, image: fixture_file_upload('spec/fixtures/example.txt')

    post.valid?
    expect(post.errors[:image]).to eq ["isn't of allowed type (allowed types: image/jpeg, image/png, image/gif)"]
  end
end

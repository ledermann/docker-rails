require 'rails_helper'

describe Clip do
  let(:clip) { Clip.new }

  it "requires Post" do
    expect(clip).to_not be_valid
    expect(clip.errors[:post]).to include("must exist")

    clip.post = build(:post)
    expect(clip).to be_valid
  end
end

describe Clip, 'created for Post' do
  let(:post) { create :post, updated_at: 10.days.ago }
  let(:clip) { create :clip, post: post  }

  it "touches post" do
    clip
    expect(post.updated_at.to_s).to eq(clip.created_at.to_s)
  end

  it "increases counter cache" do
    expect { clip }.to change(post, :clips_count).by(1)
  end

  it "has image_data" do
    expect(clip.image_data).to be_present
  end
end

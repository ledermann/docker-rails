require 'rails_helper'

describe "Posts", type: :request do
  let!(:post) { create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum') }
  let!(:clip) { create(:clip, id: 123, post: post) }

  before do
    Post.reindex
  end

  describe 'GET /posts' do
    context "without query param" do
      it "returns JSON" do
        get api_v1_posts_path(format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')

        json_data = JSON.parse(response.body)
        expect(json_data.length).to eq(1)
        expect(json_data.first.keys).to match_array(%w[id slug title content updated_at clips_count])
        expect(json_data.first['title']).to eq('Foo')
        expect(json_data.first['content']).to eq('Lorem ipsum')
      end
    end

    context "with query param" do
      it "returns JSON" do
        get api_v1_posts_path(q: 'lorem', format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')

        json_data = JSON.parse(response.body)
        expect(json_data.length).to eq(1)
        expect(json_data.first.keys).to match_array(%w[id slug title content updated_at clips_count])
        expect(json_data.first['title']).to eq('Foo')
        expect(json_data.first['content']).to eq('…<em>Lorem</em> ipsum…')
      end
    end
  end

  describe 'GET /posts/:id' do
    it "returns JSON" do
      get api_v1_post_path(id: 42, format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')

      json_data = JSON.parse(response.body)
      expect(json_data.keys).to match_array(%w[id slug title content copyright created_at updated_at clips_count clips])
      expect(json_data['title']).to eq('Foo')
      expect(json_data['content']).to eq('Lorem ipsum')

      expect(json_data['clips'].size).to eq(1)
      expect(json_data['clips'].first.keys).to match_array(%w[id filename original large thumbnail])
    end
  end
end

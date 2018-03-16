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
        expect(json_data.length).to eq(2)

        posts = json_data['posts']
        post = posts.first
        expect(post.keys).to match_array(%w[id slug title content updated_at clips_count])
        expect(post['title']).to eq('Foo')
        expect(post['content']).to eq('Lorem ipsum')

        meta = json_data['meta']
        expect(meta['total_count']).to eq(1)
      end
    end

    context "with query param" do
      it "returns JSON" do
        get api_v1_posts_path(q: 'lorem', format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')

        json_data = JSON.parse(response.body)
        expect(json_data.length).to eq(2)

        posts = json_data['posts']
        post = posts.first
        expect(post.keys).to match_array(%w[id slug title content updated_at clips_count])
        expect(post['title']).to eq('Foo')
        expect(post['content']).to eq('…<em>Lorem</em> ipsum…')
      end
    end
  end

  describe 'GET /posts/autocomplete' do
    context "finding something" do
      it "returns JSON" do
        get autocomplete_api_v1_posts_path(q: 'lorem', format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')

        json_data = JSON.parse(response.body)
        expect(json_data).to eq(%w[lorem])
      end
    end

    context "finding nothing" do
      it "returns blank string" do
        get autocomplete_api_v1_posts_path(q: 'foooo', format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq('')
      end
    end
  end

  describe 'GET /posts/:id' do
    it "returns JSON" do
      get api_v1_post_path(id: 42, format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')

      json_data = JSON.parse(response.body)

      post = json_data['post']
      expect(post.keys).to match_array(%w[id slug title content copyright created_at updated_at clips_count clips])
      expect(post['title']).to eq('Foo')
      expect(post['content']).to eq('Lorem ipsum')

      clips = post['clips']
      expect(clips.size).to eq(1)
      clip = clips.first
      expect(clip.keys).to match_array(%w[id filename original large thumbnail])
    end
  end
end

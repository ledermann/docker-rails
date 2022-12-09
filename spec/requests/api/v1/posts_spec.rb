require 'rails_helper'

include ActiveSupport::Testing::Assertions

describe "Posts", type: :request do
  let!(:post1) { create(:post, :reindex, id: 42, title: 'Foo', content: 'Lorem ipsum') }
  let!(:clip) { perform_enqueued_jobs { create(:clip, id: 123, post: post1) } }
  let!(:clip_unprocessed) { create(:clip_unprocessed, id: 124, post: post1) }

  let(:admin_user) { create(:user, is_admin: true) }
  let(:normal_user) { create(:user, is_admin: false) }

  describe 'GET /posts' do
    context "without query param" do
      it "returns JSON" do
        get api_v1_posts_path(format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

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
        expect(response.content_type).to eq('application/json; charset=utf-8')

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
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_data = JSON.parse(response.body)
        expect(json_data).to eq(%w[lorem])
      end
    end

    context "finding nothing" do
      it "returns blank string" do
        get autocomplete_api_v1_posts_path(q: 'foooo', format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_data = JSON.parse(response.body)
        expect(json_data).to eq(%w[])
      end
    end
  end

  describe 'GET /posts/:id' do
    it "returns JSON" do
      get api_v1_post_path(id: 42, format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_data = JSON.parse(response.body)

      post = json_data['post']
      expect(post.keys).to match_array(%w[id slug title content copyright created_at updated_at clips_count clips])
      expect(post['title']).to eq('Foo')
      expect(post['content']).to eq('Lorem ipsum')

      clips = post['clips']
      expect(clips.size).to eq(2)
      expect(clips.map(&:keys)).to all(match_array(%w[id filename original large thumbnail]))
      expect(clips.first['filename']).to eq('example.jpg')
      expect(clips.second['filename']).to eq(nil)
    end
  end

  describe 'POST /posts' do
    let(:params) do
      {
        post: {
          title: "This is a new post",
          content: "Some content"
        }
      }
    end

    context "authenticated as admin" do
      let(:headers) { authenticated_header(admin_user) }

      it "creates new post" do
        post(api_v1_posts_path, params:, headers:)

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.location).to eq('http://www.example.com/posts/this-is-a-new-post')

        json_data = JSON.parse(response.body)
        post = json_data['post']
        expect(post.keys).to match_array(%w[id slug title content copyright created_at updated_at clips_count clips])
        expect(post['title']).to eq('This is a new post')
        expect(post['content']).to eq('Some content')
      end
    end

    context "without admin authentication" do
      it "rejects creating post" do
        [ normal_user, nil, :invalid ].each do |auth_target|
          post(api_v1_posts_path, params:, headers: authenticated_header(auth_target))

          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'PATCH /posts/:id' do
    let(:params) do
      {
        post: {
          title: "other title"
        }
      }
    end

    context "authenticated as admin" do
      it "updates post" do
        patch(api_v1_post_path(id: 42), params:, headers: authenticated_header(admin_user))

        expect(response).to have_http_status(200)
        expect(post1.reload.title).to eq('other title')
      end
    end

    context "without admin authentication" do
      it "rejects updating post" do
        [ normal_user, nil, :invalid ].each do |auth_target|
          patch(api_v1_post_path(id: 42), params:, headers: authenticated_header(auth_target))

          expect(response).to have_http_status(401)
          expect(post1.reload.title).to eq('Foo')
        end
      end
    end
  end

  describe 'DELETE /posts/:id' do
    context "authenticated as admin" do
      it "deletes post" do
        delete api_v1_post_path(id: 42), params: {}, headers: authenticated_header(admin_user)

        expect(response).to have_http_status(204)
        expect { post1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "without admin authentication" do
      it "rejects deleting post" do
        [ normal_user, nil, :invalid ].each do |auth_target|
          delete api_v1_post_path(id: 42), params: {}, headers: authenticated_header(auth_target)

          expect(response).to have_http_status(401)
          expect { post1.reload }.to_not raise_error
        end
      end
    end
  end
end

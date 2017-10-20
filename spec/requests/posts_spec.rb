require 'rails_helper'

describe "Posts", type: :request do

  before do
    create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum')
    Post.reindex
  end

  describe 'GET /posts' do
    context "without query param" do
      describe "as HTML" do
        it "returns HTML" do
          get posts_path
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('text/html')
          expect(response.body).to match(/Foo.*Lorem ipsum/)
        end
      end

      describe "as JSON" do
        it "returns JSON" do
          get posts_path(format: :json)
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json')

          json_data = JSON.parse(response.body)
          expect(json_data.length).to eq(1)
          expect(json_data.first.keys).to match_array(%w(id title content created_at updated_at clips_count url))
          expect(json_data.first['title']).to eq('Foo')
          expect(json_data.first['content']).to eq('Lorem ipsum')
          expect(json_data.first['url']).to eq('http://www.example.com/posts/foo.json')
        end
      end
    end

    context "with query param" do
      describe "as HTML" do
        it "returns HTML" do
          get posts_path(q: 'lorem')
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('text/html')
          expect(response.body).to include('Foo')
          expect(response.body).to include('<em>Lorem</em> ipsum')
        end
      end

      describe "as JSON" do
        it "returns JSON" do
          get posts_path(q: 'lorem', format: :json)
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json')

          json_data = JSON.parse(response.body)
          expect(json_data.length).to eq(1)
          expect(json_data.first.keys).to match_array(%w(id title content created_at updated_at clips_count url))
          expect(json_data.first['title']).to eq('Foo')
          expect(json_data.first['content']).to eq('…<em>Lorem</em> ipsum…')
          expect(json_data.first['url']).to eq('http://www.example.com/posts/foo.json')
        end
      end
    end
  end

  describe 'GET /posts/:id' do
    describe "as HTML" do
      it "returns HTML" do
        get post_path(id: 42)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/html')
        expect(response.body).to match(/Foo.*Lorem ipsum/)
      end
    end

    describe "as JSON" do
      it "returns JSON" do
        get post_path(id: 42, format: :json)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')

        json_data = JSON.parse(response.body)
        expect(json_data.keys).to match_array(%w(id title content created_at updated_at clips_count))
        expect(json_data['title']).to eq('Foo')
        expect(json_data['content']).to eq('Lorem ipsum')
      end
    end
  end

end

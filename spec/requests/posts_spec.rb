require 'rails_helper'

describe "Posts", type: :request do
  let!(:post) { create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum') }
  let!(:clip) { create(:clip, id: 123, post:) }

  describe 'GET /posts' do
    context "without query param" do
      it "returns HTML" do
        get posts_path
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/html; charset=utf-8')
        expect(response.body).to match(/Foo.*Lorem ipsum/)
      end
    end

    context "with query param" do
      it "returns HTML" do
        get posts_path(q: 'lorem')
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('text/html; charset=utf-8')
        expect(response.body).to include('Foo')
        expect(response.body).to include('<em>Lorem</em> ipsum')
      end
    end
  end

  describe 'GET /posts/:id' do
    it "returns HTML" do
      get post_path(id: 42)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('text/html; charset=utf-8')
      expect(response.body).to match(/Foo.*Lorem ipsum/)
    end
  end
end

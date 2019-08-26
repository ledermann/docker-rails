require 'rails_helper'

describe "Audits", type: :request do
  let!(:post) { create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum') }

  describe 'GET /audits' do
    it "returns HTML" do
      get post_audits_path(post)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('text/html; charset=utf-8')
      expect(response.body).to match(/Audits of/)
    end
  end
end

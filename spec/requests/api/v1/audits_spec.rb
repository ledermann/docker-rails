require 'rails_helper'

describe "Audits", type: :request do
  let!(:post) { create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum') }

  describe 'GET /audits' do
    it "returns JSON" do
      get api_v1_post_audits_path(post, format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')

      json_data = JSON.parse(response.body)
      expect(json_data.length).to eq(1)
      expect(json_data.first.keys).to match_array(%w[id created_at whodunnit event])
      expect(json_data.first['event']).to eq('create')
      expect(json_data.first['whodunnit']).to eq(nil)
    end
  end
end

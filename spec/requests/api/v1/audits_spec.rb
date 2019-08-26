require 'rails_helper'

describe "Audits", type: :request do
  let!(:post) { create(:post, id: 42, title: 'Foo', content: 'Lorem ipsum') }

  describe 'GET /audits' do
    it "returns JSON" do
      get api_v1_post_audits_path(post, format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_data = JSON.parse(response.body)

      audits = json_data['audits']
      expect(audits.length).to eq(1)

      audit = audits.first
      expect(audit.keys).to match_array(%w[id created_at whodunnit event])
      expect(audit['event']).to eq('create')
      expect(audit['whodunnit']).to eq(nil)
    end
  end
end

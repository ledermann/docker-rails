require 'rails_helper'

describe "About", type: :request do
  describe 'GET /about' do
    it "returns JSON" do
      get api_v1_about_path(format: :json)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_data = JSON.parse(response.body)
      expect(json_data['rails']).to eq(Rails::VERSION::STRING)
    end
  end
end

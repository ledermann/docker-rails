require 'rails_helper'

describe "Pages", type: :request do
  describe "GET /pages" do
    it "works! (now write some real specs)" do
      get pages_path
      expect(response).to have_http_status(200)
    end
  end
end

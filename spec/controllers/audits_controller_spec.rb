require 'rails_helper'

describe AuditsController do
  let!(:post1) { create :post }
  let!(:post2) { create :post }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { post_id: post1.id }
      expect(response).to be_successful
    end
  end
end

require 'rails_helper'

describe "User token", type: :request do
  let!(:user) { User.create! email: 'me@example.com', password: 'secret' }

  describe 'POST /api/v1/user_token' do
    context "valid password" do
      it "returns JWT" do
        post api_v1_user_token_path, params: {
          auth: {
            email:    'me@example.com',
            password: 'secret'
          }
        }

        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_data = JSON.parse(response.body)
        expect(json_data['jwt']).to be_present
      end
    end

    context "invalid password" do
      it "returns 404" do
        post api_v1_user_token_path, params: {
          auth: {
            email:    'me@example.com',
            password: 'fooooo'
          }
        }

        expect(response).to have_http_status(404)
        expect(response.body).to be_blank
      end
    end

    context "invalid email" do
      it "returns 404" do
        post api_v1_user_token_path, params: {
          auth: {
            email:    'john@doe.com',
            password: 'fooooo'
          }
        }

        expect(response).to have_http_status(404)
        expect(response.body).to be_blank
      end
    end
  end
end

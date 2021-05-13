require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/list/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/list/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/list/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/list/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

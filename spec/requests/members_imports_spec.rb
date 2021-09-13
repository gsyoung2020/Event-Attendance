require 'rails_helper'

RSpec.describe "MembersImports", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/members_imports/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/members_imports/create"
      expect(response).to have_http_status(:success)
    end
  end

end

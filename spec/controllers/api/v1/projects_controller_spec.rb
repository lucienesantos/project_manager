require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  context "When return content body" do

    let!(:bradesco_project){ create(:project, name: "Bradesco's Project") }
    let!(:itau_project) { create(:project, name: "Itau's Project") }
    let!(:santander_project) { create(:project, name: "Santander's Project") }

    let(:body) { JSON.parse(response.body) }

    it "returns projects count" do
      get :index 
      expect(body.count).to eq(3)
    end

    it "returns project ordened by date of created decrescent" do
      get :index
      expect(body[0]["name"]).to eq("Santander's Project")
      expect(body[1]["name"]).to eq("Itau's Project")
      expect(body[2]["name"]).to eq("Bradesco's Project")
    end

  end  

end

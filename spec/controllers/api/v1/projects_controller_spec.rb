require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response.status).to eq(200)
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

  describe "POST #create" do
    let(:client){ create(:client) }

    context "with valid attributes" do

      let(:project_params) do
        {
          project: {
            name: "Bradesco's Project", conclusion_at: "2017-10-22 08:00:00", client_id: client.id,
          }
        }
      end

      it "request whit success return status created" do
        post :create, params: project_params
        expect(response.status).to eq(201)
        expect(response).to have_http_status(:created)
      end

      it "created a project" do
        expect{post :create, params: project_params}.to change{Project.count }.by(1)
      end

      it "returns project created" do
        post :create, params: project_params
        body = JSON.parse(response.body)

        expect(body["project"]["name"]).to eq("Bradesco's Project")
      end

    end

    context "whit invalids attributes" do
      let(:project_params) do
        {
          project: {
            name: "Bradesco's Project", conclusion_at: "1", client_id: client.id,
          }
        }
      end

      it "does not should create project" do
        expect {post :create, params: project_params}.to_not change{Project.count}
      end

      it "request return error code" do
        post :create, params: project_params
        expect(response.status).to eq(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

end

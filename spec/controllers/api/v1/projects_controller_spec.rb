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

    context "with invalids attributes" do
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

  describe "PUT #update" do
    let(:project){create(:project)}
    let(:client){ create(:client) }

    context "with valids attributes" do
      let(:project_params) do
        {
          project: {
             name: "Bradesco's Project",
          },
          id: project.id,
        }
      end

      it "request return success" do
        put :update, params: project_params
        expect(response.status).to eq(200)
      end

      it "should return project updated" do
        put :update, params: project_params
        body = JSON.parse(response.body)
        expect(body["project"]["name"]).to eq("Bradesco's Project")
      end
    end

    context "with invalids attributes" do
      let(:project_params) do
        {
          project: {
             conclusion_at: "1",
          },
          id: project.id,
        }
      end

      it "return error code" do
        put :update, params: project_params
        expect(response.status).to eq(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #conclude" do
    let(:project){ create(:project) }

    context "with existing project"
      it "request return success" do
        put :conclude, params: { id: project.id }
        expect(response.status).to eq(200)
      end

    it "return project concluded" do
      put :conclude, params: { id: project.id }
      body = JSON.parse(response.body)
      expect(body["project"]["state"]).to eq("concluded")
    end

    context "with not existing id project" do
      it "request return error" do
        put :conclude, params: {id: 5}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "request return error message" do
        put :conclude, params: {id: 5}
        body = JSON.parse(response.body)
        expect(body["errors"]).to eq("Couldn't find Project with 'id'=5")
      end
    end
  end

  describe "PATCH #archive" do
    let(:project) { create(:project) }

    it "request return success" do
      patch :archive, params: {ids: [project.id]}
      expect(response.status).to eq(204)
    end
  end

end

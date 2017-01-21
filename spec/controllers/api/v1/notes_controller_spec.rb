require 'rails_helper'

RSpec.describe Api::V1::NotesController, type: :controller do

  describe "POST #create" do
    let(:project){ create(:project) }

    context "with valides attributes" do
      let(:notes_params) do
        {
          id: project.id,
          note: {
            content: "Note addictive of project",
            project_id: project.id,
            conclude_project: 1
          }
        }
      end

      it "returns status success" do
        post :create, params: notes_params
        expect(response.status).to eq(201)
      end

      it "create a note" do
        expect{ post :create, params: notes_params}.to change{Note.count}.by(1)
      end

      it "return note create" do
        post :create, params: notes_params
        body = JSON.parse(response.body)
        expect(body["note"]["content"]).to eq("Note addictive of project")
      end
    end

    context "with invalides attributes" do

      let(:notes_params) do
        {
          id: 5,
          note: {
            content: "Note addictive of project",
          }
        }
      end

      it "return error code" do
        post :create, params: notes_params
        expect(response.status).to eq(422)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #archive" do
    let(:project){ create(:project, id: 50) }
    let!(:note){ create(:note, project_id: project.id, id: 33 )}

    it "request return success" do
      patch :archive, params: {id: project.id, note_id: note.id }
      expect(response.status).to eq(200)
    end

    it "should change archived of note" do
      patch :archive, params: {id: project.id, note_id: note.id}
      body = JSON.parse(response.body)
      expect(body["archived"]).to eq(true)
    end
  end

  describe "GET #index" do

    context "With 25 notes" do
      let!(:client) {create(:client)}
      let!(:project) {create(:project, client_id: client.id)}

      before do
        FactoryGirl.create_list(:note, 25, project_id: project.id)
      end

      it "should return only 20 projects on first page" do
        get :index, params: {id: project.id, page: 1, per_page: 20}
        body = JSON.parse(response.body)
        expect(body.count).to eq(20)
      end

      it "should return only 5 notes" do
        get :index, params: {id: project.id, page: 2, per_page: 20}
        body = JSON.parse(response.body)
        expect(body.count).to eq(5)
      end
    end


    context "Notes archiveds" do
      let(:client){create(:client)}
      let(:project_bradesco){create(:project, client_id: client.id)}
      let(:project_itau){create(:project, client_id: client.id)}

      let!(:note_add_contract_itau){create(:note, project_id: project_itau.id, content: "Add contract Itau")}
      let!(:note_add_employee_itau){create(:note, project_id: project_itau.id, content: "Add employee Itau")}
      let!(:note_add_contract_bradesco){create(:note, project_id: project_bradesco.id, content: "Add contract Bradesco")}
      let!(:note_remove_employee_itau){create(:note, project_id: project_itau.id, content: "Add employee Itau", archived: true)}

      it "return count notes by project not archiveds and order by create date decrescent" do
        get :index, params: {id: project_itau.id}
        body = JSON.parse(response.body)
        expect(body.count).to eq(2)
      end
    end
  end

end

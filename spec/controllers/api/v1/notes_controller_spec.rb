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
    let(:project){ create(:project) }
    let!(:note){ create(:note, project_id: project.id )}

    it "request return success" do
      patch :archive, params: {id: note.id}
      expect(response.status).to eq(200)
    end

    it "should change archived of note" do
      patch :archive, params: {id: note.id }
      body = JSON.parse(response.body)
      expect(body["archived"]).to eq(true)
    end
  end

end

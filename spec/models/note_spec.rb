require 'rails_helper'

RSpec.describe Note, type: :model do

  context "Associations" do
    it {is_expected.to belong_to(:project)}
  end

  context "Validations" do
    it {is_expected.to validate_presence_of(:content)}
    it {is_expected.to validate_presence_of(:project)}
  end

  describe "#complete_status_project" do

    let(:project){ create(:project) }
    let(:note){ create(:note, content: "Adding note for project", project_id: project.id, conclude_project: 1)}

    context "with conclude_project true" do
      it "should change state and conclusion date " do
        Timecop.freeze(Date.today) do
          note.save
          expect(note.project.state).to eq("concluded")
          expect(note.project.conclusion_at).to eq(Time.zone.now)
        end
      end
    end
  end

  describe "#sort_by_creation" do

    let(:client){create(:client)}
    let(:project_bradesco){create(:project, client_id: client.id)}
    let(:project_itau){create(:project, client_id: client.id)}

    let!(:note_add_contract){create(:note, project_id: project_itau.id, content: "Add contract Itau")}
    let!(:note_add_employee){create(:note, project_id: project_itau.id, content: "Add employee Itau")}
    let!(:note_remove_contract){create(:note, project_id: project_itau.id, content: "Remove contract")}

    it "return notes by create date decrescent" do
      notes = Note.sort_by_creation()

      expect(notes[0].content).to eq("Remove contract")
      expect(notes[1].content).to eq("Add employee Itau")
      expect(notes[2].content).to eq("Add contract Itau")
    end
  end

  describe "#by_project_id" do

    let(:client){create(:client)}
    let(:project_bradesco){create(:project, client_id: client.id)}
    let(:project_itau){create(:project, client_id: client.id)}

    let!(:note_add_contract_itau){create(:note, project_id: project_itau.id, content: "Add contract Itau")}
    let!(:note_add_employee_itau){create(:note, project_id: project_itau.id, content: "Add employee Itau")}
    let!(:note_add_contract_bradesco){create(:note, project_id: project_bradesco.id, content: "Add contract Bradesco")}
    let!(:note_remove_employee_itau){create(:note, project_id: project_itau.id, content: "Add employee Itau")}

    it "return count notes by project id" do
      notes = Note.by_project_id(project_itau.id)
      note_remove_employee_itau.soft_delete
      expect(notes.count).to eq(2)
    end

    it "return the notes by project id" do
      notes = Note.by_project_id(project_itau.id)
      expect(notes[0].project_id).to eq(project_itau.id)
      expect(notes[1].project_id).to eq(project_itau.id)
    end
  end

end

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

end

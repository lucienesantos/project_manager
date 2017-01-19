require 'rails_helper'

RSpec.describe Project, type: :model do

  context "Associations" do
    it {is_expected.to belong_to(:client)}
    it {is_expected.to have_many(:notes)}
  end

  context "Validations" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_presence_of(:client)}
    it {is_expected.to validate_presence_of(:conclusion_at)}
    it {is_expected.to validate_presence_of(:client)}
    it {is_expected.to validate_inclusion_of(:state).in_array(described_class::STATES)}

  end

  describe "#conclude" do
    let(:project) {create(:project)}

    it "should change state of the project and conclusion_at" do
      Timecop.freeze(Date.today) do
        project.conclude
        expect(project.state).to eq("concluded")
        expect(project.conclusion_at).to eq(Time.zone.now)
      end
    end
  end

  describe "#soft_delete" do
    let!(:project){ create(:project)}

    it "should change archived end archived_at of project" do
      Timecop.freeze(Date.today) do
        project.soft_delete
        expect(project.archived).to eq(true)
        expect(project.archived_at).to eq(Time.zone.now)
      end
    end
  end

  describe "#sort_by_creation" do
    let!(:project_google){ create(:project, name: "Project's Google")}
    let!(:project_firefox){ create(:project, name: "Project's Firefox")}
    let!(:project_safari){ create(:project, name: "Project's Safari")}

    it "should return projects by date create in order decrescent " do
      projects = Project.sort_by_creation
      expect(projects[0].name).to eq("Project's Safari")
      expect(projects[1].name).to eq("Project's Firefox")
      expect(projects[2].name).to eq("Project's Google")
    end

    context "with project archived" do
      it "should return only project not archived " do

        project_safari.soft_delete

        projects = Project.sort_by_creation
        expect(projects[0].name).to eq("Project's Firefox")
        expect(projects[1].name).to eq("Project's Google")
      end
    end
  end
end

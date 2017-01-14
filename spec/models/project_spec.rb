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

end

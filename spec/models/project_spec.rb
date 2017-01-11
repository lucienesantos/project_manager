require 'rails_helper'

RSpec.describe Project, type: :model do

  context "Associations" do
    it {is_expected.to belong_to(:client)}
  end

  context "Validations" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_presence_of(:client)}
    it {is_expected.to validate_presence_of(:conclusion_at)}
    it {is_expected.to validate_presence_of(:client)}

    it {is_expected.to validate_inclusion_of(:state).in_array(described_class::STATES)}


  end

end

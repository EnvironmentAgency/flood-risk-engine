require "rails_helper"

module FloodRiskEngine
  RSpec.describe Address, type: :model do
    it { is_expected.to belong_to(:contact) }
    it { is_expected.to have_one(:location).dependent(:restrict_with_exception) }
  end
end

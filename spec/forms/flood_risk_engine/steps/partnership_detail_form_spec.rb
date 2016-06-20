require "rails_helper"
module FloodRiskEngine
  module Steps

    describe PartnershipDetailForm, type: :form do
      let(:enrollment) { FactoryGirl.create(:enrollment) }
      let(:model_class) { Enrollment }
      subject { described_class.factory(enrollment) }

      it { is_expected.to be_a(described_class) }

      it "returns true on save" do
        expect(subject.save).to be(true)
      end

      it "returns true on validate" do
        expect(subject.validate({})).to be(true)
      end
    end
  end
end

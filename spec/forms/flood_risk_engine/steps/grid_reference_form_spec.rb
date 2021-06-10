require "rails_helper"
require_relative "../../../support/shared_examples/form_objects"

module FloodRiskEngine
  module Steps
    RSpec.describe GridReferenceForm, type: :form do
      let(:params_key) { :grid_reference }
      let(:enrollment) { FactoryBot.create(:enrollment) }
      let(:model_class) { Location }
      let(:grid_reference) { "ST 58132 72695" }
      let(:description) { Faker::Lorem.sentence(word_count: 3) }
      let(:dredging_exemption) { FactoryBot.create(:exemption, code: "FRA23") }
      let(:dredging_length) { "" }

      subject { described_class.factory(enrollment) }

      it_behaves_like "a form object"

      it { is_expected.to be_a(described_class) }
      it { is_expected.to respond_to(:grid_reference) }

      let(:params) do
        {
          params_key => {
            grid_reference: grid_reference,
            description: description,
            dredging_length: dredging_length
          }
        }
      end

      let(:numeric_error_message) do
        I18n.t("#{locale_key}.errors.dredging_length.numeric",
               min: FloodRiskEngine.config.minumum_dredging_length_in_metres,
               max: FloodRiskEngine.config.maximum_dredging_length_in_metres)
      end

      describe "#validate" do
        let(:error_message) { subject.errors.messages[:grid_reference] }
        let(:locale_key) { described_class.locale_key }

        it "should return true with a valid grid reference" do
          expect(subject.validate(params)).to eq(true)
        end

        it "should ignore spacing" do
          grid_reference.gsub!(/\s/, "")
          expect(subject.validate(params)).to eq(true)
        end

        context "with an invalid grid reference" do
          let(:grid_reference) { "invalid" }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.grid_reference.invalid")])
          end
        end

        context "with an out of range grid reference" do
          let(:grid_reference) { "AA 58132 72695" }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.grid_reference.invalid")])
          end
        end

        context "with a short grid reference" do
          let(:grid_reference) { "ST 5811 7261" }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.grid_reference.invalid")])
          end
        end

        context "with a blank grid reference" do
          let(:grid_reference) { "" }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.grid_reference.blank")])
          end
        end

        context "with a blank description" do
          let(:description) { "" }
          let(:error_message) { subject.errors.messages[:description] }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.description.blank")])
          end
        end

        context "with a long description" do
          let(:description) { Faker::Lorem.characters(number: 501) }
          let(:error_message) { subject.errors.messages[:description] }

          it "should return false" do
            expect(subject.validate(params)).to eq(false)
          end

          it "should display the locale error message" do
            subject.validate(params)
            expect(error_message)
              .to eq([I18n.t("#{locale_key}.errors.description.too_long", max: 500)])
          end
        end

        context "when exemptions include dredging long stretch" do
          let(:error_message) { subject.errors.messages[:dredging_length] }

          before do
            enrollment.exemptions << dredging_exemption
          end

          context "with dredging_length" do
            let(:dredging_length) { "350" }
            it "should validate" do
              expect(subject.validate(params)).to eq(true)
            end
          end

          context "and no dredging_length entered" do
            it "should return false" do
              expect(subject.validate(params)).to eq(false)
            end

            it "should display the locale error message" do
              subject.validate(params)
              expect(error_message)
                .to eq([I18n.t("#{locale_key}.errors.dredging_length.blank")])
            end
          end

          context "with too long a dredging_length" do
            let(:dredging_length) { "150,000" }
            it "should return false" do
              expect(subject.validate(params)).to eq(false)
            end

            it "should display the locale error message" do
              subject.validate(params)
              expect(error_message).to eq([numeric_error_message])
            end
          end

          context "with a dredging_length of zero" do
            let(:dredging_length) { "0" }
            it "should return false" do
              expect(subject.validate(params)).to eq(false)
            end

            it "should display the locale error message" do
              subject.validate(params)
              expect(error_message).to eq([numeric_error_message])
            end
          end
        end
      end

      describe "#save" do
        it "should save the grid reference to enrollment.exemption_location" do
          @grid_reference = grid_reference

          expect(UpdateWaterManagementAreaJob).to receive(:perform_later).and_return({})

          subject.validate(params)
          expect(subject.save).to eq(true)
          enrollment.reload
          expect(
            enrollment.exemption_location.grid_reference
          ).to eq(@grid_reference)
        end
      end

      describe "#require_dredging_length?" do
        it "should be false" do
          expect(subject.require_dredging_length?).to be_falsey
        end

        context "with too long a dredging_length" do
          before do
            enrollment.exemptions << dredging_exemption
          end

          it "should be true" do
            expect(subject.require_dredging_length?).to be_truthy
          end
        end
      end
    end
  end
end

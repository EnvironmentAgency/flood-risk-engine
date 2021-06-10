require "rails_helper"

module FloodRiskEngine
  RSpec.describe Enrollments::ExemptionsController, type: :controller do
    routes { Engine.routes }
    render_views
    let(:exemption) { FactoryBot.create(:exemption) }
    let(:other_exemption) { FactoryBot.create(:exemption) }
    let(:enrollment) do
      FactoryBot.create(
        :enrollment,
        step: :check_exemptions,
        exemptions: exemptions
      )
    end

    describe ".destroy" do
      context "when more than one exemptions" do
        let(:exemptions) { [exemption, other_exemption] }

        before do
          delete :destroy, params: { id: exemption, enrollment_id: enrollment }
        end

        describe "removing an exemption" do
          it "should redirect to current step" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, enrollment.step)
            )
          end

          it "should remove the exemption" do
            expect(enrollment.reload.exemptions).to eq([other_exemption])
          end
        end
      end

      context "when one exemption" do
        let(:exemptions) { [exemption] }

        before do
          delete :destroy, params: { id: exemption, enrollment_id: enrollment }
        end

        describe "removing an exemption" do
          it "should redirect to previous step" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, enrollment.previous_step)
            )
          end

          it "should remove the exemption" do
            expect(enrollment.reload.exemptions).to eq([])
          end
        end
      end
    end

    describe ".show" do
      let(:exemptions) { [exemption, other_exemption] }

      before do
        get :show, params: { id: exemption, enrollment_id: enrollment }
      end

      describe "removing an exemption" do
        it "should redirect to current step" do
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, enrollment.step)
          )
        end

        it "should remove the exemption" do
          expect(enrollment.reload.exemptions).to eq([other_exemption])
        end
      end
    end
  end
end

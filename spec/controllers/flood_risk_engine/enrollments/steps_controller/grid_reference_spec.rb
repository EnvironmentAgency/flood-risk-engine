require "rails_helper"
module FloodRiskEngine
  module Enrollments
    describe StepsController, type: :controller do
      routes { Engine.routes }
      render_views
      let(:enrollment) { FactoryBot.create(:enrollment, step: step) }
      let(:dredging_exemption) { FactoryBot.create(:exemption, code: "FRA23") }

      context "grid_reference" do
        let(:step) { "grid_reference" }

        before do
          set_journey_token
          get :show, params: { id: step, enrollment_id: enrollment }
        end

        it "uses GridReferenceForm" do
          expect(controller.send(:form)).to be_a(Steps::GridReferenceForm)
        end

        it "diplays header" do
          header_text = t("flood_risk_engine.enrollments.steps.grid_reference.heading")
          expect(response.body).to have_tag(:h1, text: /#{header_text}/)
        end

        it "diplays Continue button" do
          expect(response.body).to have_selector("input[type=submit][value='Continue']")
        end

        it "should not display dredging_length input" do
          expect(response.body).to_not have_tag(:input, with: { name: "#{step}[dredging_length]" })
        end

        context "when exemptions include dredging long stretch" do
          let(:enrollment) do
            enrollment = FactoryBot.create(:enrollment, step: step)
            enrollment.exemptions << dredging_exemption
            enrollment
          end

          it "should display dredging_length input" do
            expect(response.body).to have_tag(:input, with: { name: "#{step}[dredging_length]" })
          end
        end

        it "should display dredging_length input" do
          expect(response.body).to have_tag(:textarea, with: { name: "#{step}[description]" })
        end
      end
    end
  end
end

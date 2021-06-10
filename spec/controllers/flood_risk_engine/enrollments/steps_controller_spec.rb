require "rails_helper"
module FloodRiskEngine
  module Enrollments
    RSpec.describe StepsController, type: :controller do
      routes { Engine.routes }
      render_views
      let(:enrollment) { FactoryBot.create(:enrollment, step: step) }
      let(:step) { WorkFlow::Definitions.start.first }

      describe "show action without journey token in session" do
        let(:enrollment) do
          FactoryBot.create(:enrollment, step: step)
        end

        it "redirects_to error page" do
          get :show, params: { id: step, enrollment_id: enrollment }
          expect(response).to redirect_to(error_path(:step_not_valid))
        end

        context "when app configured to allow another browser" do
          let(:config) { FloodRiskEngine.config }
          before do
            config.require_journey_completed_in_same_browser = false
          end

          it "renders step page" do
            get :show, params: { id: step, enrollment_id: enrollment }
            expect(response).to have_http_status(:success)
          end

          after do
            config.require_journey_completed_in_same_browser = true
          end
        end
      end

      context "step unknown" do
        it "redirects to current step" do
          set_journey_token
          get :show, params: { id: "unknown", enrollment_id: enrollment }
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, step)
          )
        end
      end
    end
  end
end

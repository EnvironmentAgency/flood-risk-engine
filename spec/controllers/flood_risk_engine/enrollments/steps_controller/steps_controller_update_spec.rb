require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views
    let(:steps) { WorkFlow::Definitions.start }
    let(:enrollment) { FactoryGirl.create(:enrollment, step: step) }

    describe "update action" do
      let(:step) { steps[1] }
      let(:next_step) { steps[2] }

      before do
        expect_any_instance_of(Steps::BaseForm).to(
          receive(:validate).and_return(validation_result)
        )
        put(
          :update,
          id: step,
          enrollment_id: enrollment
        )
      end

      context "on success" do
        let(:validation_result) { true }

        it "should redirect to next step on success" do
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, next_step)
          )
        end
      end

      context "failure" do
        let(:validation_result) { false }

        it "should stay on the current step" do
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
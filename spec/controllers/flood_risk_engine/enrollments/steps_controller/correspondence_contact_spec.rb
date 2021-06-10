require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views

    let(:enrollment) { FactoryBot.create(:page_correspondence_contact) }

    let(:reform_class) { Steps::CorrespondenceContactNameForm }

    context "CorrespondenceContact Name " do
      let(:step) { :correspondence_contact_name }

      before do
        set_journey_token
        get :show, params: { id: step, enrollment_id: enrollment }
      end

      it "uses CorrespondenceContactNameForm" do
        expect(controller.send(:form)).to be_a(reform_class)
      end

      it "diplays header" do
        header_text = t("#{reform_class.locale_key}.heading")
        expect(response.body).to have_tag :h1, text: /#{header_text}/
      end

      it "diplays Continue button" do
        expect(response.body).to have_selector("input[type=submit][value='Continue']")
      end

      context "with invalid params" do
        let(:invalid_attributes) {
          { full_name: "12345 not a valid name **" }
        }

        it "assigns the enrollment as @enrollment" do
          params = { id: step, enrollment_id: enrollment }.merge(invalid_attributes)
          put :update, params: params
          expect(assigns(:enrollment)).to eq(enrollment)
        end

        it "does not change the state" do
          params = { id: step, enrollment_id: enrollment }.merge(invalid_attributes)
          put :update, params: params
          expect(assigns(:enrollment).step).to eq(step.to_s)
        end

        it "redirects back to show with check for errors" do
          put :update, params: { id: step, enrollment_id: enrollment, step => invalid_attributes }
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, step, check_for_error: true)
          )
        end

        it "displays error on rendering show" do
          params = { id: step, enrollment_id: enrollment, check_for_error: true }
          session = { error_params: { step => invalid_attributes } }
          expected_error = I18n.t("flood_risk_engine.validation_errors.full_name.invalid")

          get :show, params: params, session: session
          expect(response.body).to have_tag :a, text: expected_error
        end
      end
    end
  end
end

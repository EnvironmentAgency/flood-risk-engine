require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views

    let(:enrollment) { FactoryBot.create(:page_local_authority_address) }
    let(:reform_class) { Steps::LocalAuthorityAddressForm }
    let(:valid_post_code) { "BS1 5AH" }
    let(:header_text) { t("#{reform_class.locale_key}.heading") }

    before do
      set_journey_token
    end

    before(:each) { VCR.insert_cassette("address_lookup_valid_postcode", allow_playback_repeats: true) }
    after(:each) { VCR.eject_cassette }

    context "LocalAuthorityAddressForm" do
      let(:step) { :local_authority_address }

      it "uses LocalAuthorityAddressForm" do
        get :show, params: { id: step, enrollment_id: enrollment }
        expect(controller.send(:form)).to be_a(reform_class)
      end

      it "diplays header" do
        get :show, params: { id: step, enrollment_id: enrollment }
        expect(response.body).to have_tag :h1, text: /#{header_text}/
      end

      let(:match_initial_url_step) { /You are being <a href=\"\S+local_authority_address/ }

      context "with valid params" do
        let(:valid_attributes) do
          {
            "#{step}":
              {
                postcode: valid_post_code,
                uprn: "340116"
              }
          }
        end
        let(:params) do
          { id: step, enrollment_id: enrollment }.merge!(valid_attributes)
        end

        it "creates the address when valid UK UPRN supplied via drop down rendering process_address" do
          put :update, params: params, session: session

          expect(enrollment.organisation.primary_address.address_type).to eq "primary"
          expect(enrollment.organisation.primary_address.addressable_id).to eq enrollment.organisation.id
          expect(enrollment.organisation.primary_address.postcode).to eq valid_attributes[step][:postcode]
          expect(enrollment.organisation.primary_address.uprn.to_s).to eq valid_attributes[step][:uprn]

          expect(response).to redirect_to(enrollment_step_path(enrollment, enrollment.next_step))
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) {
          {
            "#{step}":
              {
                uprn: "" # User clicks Continue before selecting an address from the Dropdown
              }
          }
        }

        let(:params) { { id: step, enrollment_id: enrollment }.merge(invalid_attributes) }

        it "assigns the enrollment as @enrollment" do
          put :update, params: params, session: session
          expect(assigns(:enrollment)).to eq(enrollment)
        end

        it "redirects back to show with check for errors when user doesn't select address from dropdown" do
          put :update, params: params, session: session
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, step, check_for_error: true)
          )
        end

        it "displays blank error when user does not select address from dropdown" do
          params = { id: step, enrollment_id: enrollment, check_for_error: true }
          session = { error_params: { step => invalid_attributes } }

          get :show, params: params, session: session

          expected_error = I18n.t("flood_risk_engine.validation_errors.uprn.blank")
          expect(response.body).to have_tag :a, text: expected_error
        end

        it "does not change the state" do
          put :update, params: params, session: session
          expect(assigns(:enrollment).step).to eq(step.to_s)
        end
      end
    end
  end
end

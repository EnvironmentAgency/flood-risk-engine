require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views

    let(:enrollment) { FactoryBot.create(:page_local_authority_postcode) }

    let(:reform_class) { Steps::LocalAuthorityPostcodeForm }

    def put_update(params)
      put(:update, params: params, session: session)
    end

    before do
      set_journey_token
    end

    context "LocalAuthorityPostcodeForm" do
      let(:step) { :local_authority_postcode }

      before do
        get :show, params: { id: step, enrollment_id: enrollment }
      end

      it "uses LocalAuthorityPostcodeForm" do
        expect(controller.send(:form)).to be_a(reform_class)
      end

      it "diplays header" do
        header_text = t("#{reform_class.locale_key}.heading")
        expect(response.body).to have_tag :h1, text: /#{header_text}/
      end

      it "diplays Continue button" do
        expect(response.body).to have_selector("input[type=submit][value='Continue']")
      end

      it "displays OS Places notice" do
        expect(response.body).to have_selector("p#os-notice")
      end

      let(:valid_attributes) { { local_authority_postcode: { postcode: "BS1 5AH" } } }

      let(:match_initial_url_step) { /You are being <a href=\"\S+local_authority_postcode/ }

      context "with valid params" do
        it "steps to next page when valid UK postcode supplied on rendering show" do
          VCR.use_cassette("address_lookup_valid_postcode") do
            params = { id: step, enrollment_id: enrollment }.merge valid_attributes

            put_update(params)

            expect(response).to redirect_to(enrollment_step_path(enrollment, enrollment.next_step))
          end
        end

        it "redirects when Postcode lookup service is NOT available" do
          params = { id: step, enrollment_id: enrollment }.merge valid_attributes

          allow_any_instance_of(DefraRuby::Address::Response).to receive(:successful?).and_return(false)

          put_update(params)

          expected_regexp = /#{match_initial_url_step}\?check_for_error=true">redirected/
          expect(response.body).to match expected_regexp
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) { { postcode: "BS1 " } }

        it "assigns the enrollment as @enrollment" do
          put_update(id: step, enrollment_id: enrollment)
          expect(assigns(:enrollment)).to eq(enrollment)
        end

        it "redirects with check_for_error when invalid postcode supplied on update" do
          params = { id: step, enrollment_id: enrollment, local_authority_postcode: invalid_attributes }

          put_update(params)

          expected_regexp = /#{match_initial_url_step}\?check_for_error=true">redirected/

          expect(response.body).to match expected_regexp
        end

        it "does not change the state" do
          put_update(id: step, enrollment_id: enrollment)
          expect(assigns(:enrollment).step).to eq(step.to_s)
        end

        it "redirects back to show with check for errors" do
          put(:update, params: { id: step, enrollment_id: enrollment, step => invalid_attributes })
          expect(response).to redirect_to(
            enrollment_step_path(enrollment, step, check_for_error: true)
          )
        end

        context("check for errors") do
          let(:params) { { id: step, enrollment_id: enrollment, check_for_error: true } }

          it "displays blank error when no postcode supplied on rendering show" do
            session = { error_params: { step => { postcode: "" } } }
            expected_error = I18n.t("flood_risk_engine.validation_errors.postcode.blank")

            get(:show, params: params, session: session)
            expect(response.body).to have_tag :a, text: expected_error
          end

          it "displays enter valid postcode error when non full UK postcode supplied" do
            session = { error_params: { step => { postcode: "BS6 " } } }
            expected_error = I18n.t("flood_risk_engine.validation_errors.postcode.enter_a_valid_postcode")

            get(:show, params: params, session: session)
            expect(response.body).to have_tag :a, text: expected_error
          end

          let(:postcode_valid_but_no_addresses) { "BS9 9XX" }

          it "displays no addresses found AND manual entry link when lookup service returns no addresses" do
            session = { error_params: { step => { postcode: postcode_valid_but_no_addresses } } }

            stub_data = double(
              results: [],
              successful?: false,
              error: DefraRuby::Address::NoMatchError
            )

            expect(FloodRiskEngine::AddressLookupService).to receive(:run).and_return(stub_data)

            get(:show, params: params, session: session)

            expected_error = I18n.t("flood_risk_engine.validation_errors.postcode.no_addresses_found")
            expect(response.body).to have_tag :a, text: expected_error

            expect_manual_entry = I18n.t("flood_risk_engine.enrollments.addresses.manual_entry")
            expect(response.body).to have_tag :a, text: expect_manual_entry
          end

          it "displays enter service not working error when Postcode lookup service is NOT available" do
            session = {
              error_params: {
                step => { postcode: "BS1 5AH" } # Postcode must be valid to trigger the lookup error
              }
            }

            stub_data = double(
              results: [],
              successful?: false,
              error: "foo"
            )

            expect(FloodRiskEngine::AddressLookupService).to receive(:run).and_return(stub_data)

            get(:show, params: params, session: session)

            expected_error = I18n.t("flood_risk_engine.validation_errors.postcode.service_unavailable")
            expect(response.body).to have_tag :a, text: expected_error

            expect_manual_entry = I18n.t("flood_risk_engine.enrollments.addresses.manual_entry")
            expect(response.body).to have_tag :a, text: expect_manual_entry
          end
        end
      end
    end
  end
end

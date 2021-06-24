# frozen_string_literal: true

require "rails_helper"

module FloodRiskEngine
  RSpec.describe "CheckYourAnswersForms", type: :request do
    include_examples "GET flexible form", "check_your_answers_form"

    include_examples "POST without params form", "check_your_answers_form"

    describe "GET back_check_your_answers_forms_path" do
      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(:new_registration,
                 workflow_state: "check_your_answers_form")
        end

        context "when the back action is triggered" do
          it "returns a 302 response and redirects to the additional_contact_email form" do
            get back_check_your_answers_forms_path(transient_registration[:token])

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(new_additional_contact_email_form_path(transient_registration[:token]))
          end
        end
      end

      context "when the transient registration is in the wrong state" do
        let(:transient_registration) do
          create(:new_registration,
                 workflow_state: "declaration_form")
        end

        context "when the back action is triggered" do
          it "returns a 302 response and redirects to the correct form for the state" do
            get back_check_your_answers_forms_path(transient_registration[:token])

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(new_declaration_form_path(transient_registration[:token]))
          end
        end
      end
    end
  end
end

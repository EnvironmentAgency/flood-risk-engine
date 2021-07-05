# frozen_string_literal: true

require "rails_helper"

module FloodRiskEngine
  RSpec.describe "ContactPhoneForms", type: :request do
    describe "GET contact_phone_form_path" do
      include_examples "GET flexible form", "contact_phone_form"
    end

    describe "POST contact_phone_form_path" do
      let(:transient_registration) do
        create(:new_registration, workflow_state: "contact_phone_form")
      end

      include_examples "POST form",
                       "contact_phone_form",
                       valid_params: { contact_phone: "01234 567890" },
                       invalid_params: { contact_phone: "foo" }
    end

    describe "GET back_contact_phone_forms_path" do
      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(:new_registration,
                 workflow_state: "contact_phone_form")
        end

        context "when the back action is triggered" do
          it "returns a 302 response and redirects to the contact_name form" do
            get back_contact_phone_forms_path(transient_registration[:token])

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(new_contact_name_form_path(transient_registration[:token]))
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
            get back_contact_phone_forms_path(transient_registration[:token])

            expect(response).to have_http_status(302)
            expect(response).to redirect_to(new_declaration_form_path(transient_registration[:token]))
          end
        end
      end
    end
  end
end

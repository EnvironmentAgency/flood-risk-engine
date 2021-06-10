require "rails_helper"

module FloodRiskEngine

  RSpec.describe Enrollments::PagesController, type: :controller do
    routes { Engine.routes }
    render_views

    context "Given I'm on the Declaration page" do
      let(:enrollment) { FactoryBot.create(:page_declaration) }

      it "When I click the privacy policy link Then the Privacy Policy page will open in new tab" do
        get :show, params: { id: "privacy_policy", enrollment_id: enrollment }

        expect(response.body).to have_text "Privacy Policy"
      end

      it "When I click the cookies link Then the Cookies page will open in new tab" do
        get :show, params: { id: "cookies", enrollment_id: enrollment }

        expect(response.body).to have_text t("pages.cookies.heading_h1")
        expect(response.body).to_not include "translation missing:"
      end
    end

    context "Given I'm on the local authority postcode page" do
      let(:enrollment) { FactoryBot.create(:page_local_authority_postcode) }

      it "When I click the t&c's link Then the OS Places T&C's page will open in a new tab" do
        get :show, params: { id: "os_places_terms", enrollment_id: enrollment }

        expect(response.body).to have_text t("pages.os_places_terms.heading_h1")
        expect(response.body).to_not include "translation missing:"
      end
    end
  end
end

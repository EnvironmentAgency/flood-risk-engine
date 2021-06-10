require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views

    let(:enrollment) do
      create(:enrollment,
             :with_local_authority,
             :with_exemption,
             :with_exemption_location,
             step: step)
    end

    let(:reform_class)  { Steps::CheckYourAnswersForm }
    let(:step)          { :check_your_answers }
    let(:locale_scope)  { "flood_risk_engine.enrollments.steps.#{step}" }
    let(:partner)       { nil }

    def t(key)
      I18n.t(key, scope: locale_scope)
    end

    def row_t(row_name, key)
      I18n.t(key, scope: "#{locale_scope}.rows.#{row_name}")
    end

    before do
      set_journey_token
      partner # ensure partner is built (if present) before get
      get :show, params: { id: step, enrollment_id: enrollment }
    end

    it "uses the correct form class" do
      expect(controller.send(:form)).to be_a(reform_class)
    end

    describe "displays correct static content" do
      it "step heading" do
        expect(response.body).to have_tag :h1, text: /#{t(:heading)}/
      end

      it "table heading" do
        expect(response.body).to have_tag :h2, text: /#{t(:table_heading)}/
      end

      it "table summary" do
        expect(response.body).to have_tag :caption, text: /#{t(:table_summary)}/
      end
    end

    describe "rows" do
      it "grid_reference" do
        tr = "table tbody tr[@data-row='grid_reference']"
        expect(response.body).to have_selector(tr)
        title = row_t(:grid_reference, :title)
        expect(response.body).to have_tag("#{tr} th", text: /#{title}/)
        value = enrollment.exemption_location.grid_reference
        expect(response.body).to have_tag("#{tr} td", text: /#{value}/)
      end

      it "location_description" do
        tr = "table tbody tr[@data-row='location_description']"
        expect(response.body).to have_selector(tr)
        title = row_t(:location_description, :title)
        expect(response.body).to have_tag("#{tr} th", text: /#{title}/)
        value = enrollment.exemption_location.description
        expect(response.body).to have_tag("#{tr} td", text: /#{value}/)
      end

      it "organisation_type" do
        tr = "table tbody tr[@data-row='organisation_type']"
        expect(response.body).to have_selector(tr)
        title = row_t(:organisation_type, :title)
        expect(response.body).to have_tag("#{tr} th", text: /#{title}/)
        value = I18n.t("organisation_types.#{enrollment.organisation.org_type}")
        expect(response.body).to have_tag("#{tr} td", text: /#{value}/)
      end

      it "organisation_name" do
        tr = "table tbody tr[@data-row='organisation_name']"
        expect(response.body).to have_selector(tr)
      end

      it "should not have responsible_partner" do
        tr = "table tbody tr[@data-row='responsible_partner']"
        expect(response.body).not_to have_selector(tr)
      end
    end

    context "with partnership" do
      let(:address) { FactoryBot.create(:address) }
      let(:contact) { FactoryBot.create(:contact, address: address) }
      let(:enrollment) do
        FactoryBot.create(
          :enrollment,
          :with_partnership,
          :with_exemption,
          :with_exemption_location,
          step: step
        )
      end
      let(:partner) do
        FactoryBot.create(
          :partner,
          contact: contact,
          organisation: enrollment.organisation
        )
      end

      it "should not include organisation_name" do
        tr = "table tbody tr[@data-row='organisation_name']"
        expect(response.body).not_to have_selector(tr)
      end

      it "responsible_partner" do
        tr = "table tbody tr[@data-row='responsible_partner']"
        expect(response.body).to have_selector(tr)
      end
    end

    context "with dredging exemption" do
      let(:enrollment) do
        FactoryBot.create(
          :enrollment,
          :with_partnership,
          :with_dredging_exemption,
          :with_exemption_location,
          step: step
        )
      end

      it "should include dredging length" do
        tr = "table tbody tr[@data-row='dredging_length']"
        expect(response.body).to have_selector(tr)
      end
    end
  end
end

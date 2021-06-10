require "rails_helper"
module FloodRiskEngine
  describe Enrollments::StepsController, type: :controller do
    routes { Engine.routes }
    render_views

    let(:enrollment) { FactoryBot.create(:page_confirmation) }
    let(:reform_class) { Steps::ConfirmationForm }

    context "Confirmation Page " do
      let(:step) { :confirmation }

      before do
        set_journey_token
        get :show, params: { id: step, enrollment_id: enrollment }
      end

      it "uses ConfirmationForm" do
        expect(controller.send(:form)).to be_a(reform_class)
      end

      it "diplays custom header" do
        header_text = t("#{reform_class.locale_key}.heading")
        expect(response.body).to have_text header_text
        expect(response.body).to have_tag :div, class: /govuk-box-highlight/
      end

      context "visiting" do
        it "assigns the enrollment as @enrollment" do
          expect(assigns(:enrollment)).to eq(enrollment)
        end

        it "does NOT display a continue button" do
          expect(response.body).to_not have_selector("input[type=submit]")
        end

        it "link to guidance open in a seperate window" do
          url = t("#{reform_class.locale_key}.activities_url")
          expect(response.body).to have_selector("a[href='#{url}'][target='_blank']")
        end

        it "contains link to feedback page" do
          expect(response.body).to have_selector("a[href='#{FloodRiskEngine.feedback_page_url}']")
        end
      end
    end
  end
end

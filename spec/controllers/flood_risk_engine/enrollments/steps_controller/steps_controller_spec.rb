require "rails_helper"
module FloodRiskEngine
  module Enrollments
    describe StepsController, type: :controller do
      routes { Engine.routes }
      render_views

      let(:step) { :unknown }
      let(:enrollment) do
        FactoryBot.create(:enrollment, :with_local_authority, step: step)
      end

      before do
        set_journey_token
        get :show, params: { id: step, enrollment_id: enrollment }
      end

      it "should not diplay Continue button" do
        expect(response.body).not_to have_selector("input[type=submit][value='Continue']")
      end
    end
  end
end

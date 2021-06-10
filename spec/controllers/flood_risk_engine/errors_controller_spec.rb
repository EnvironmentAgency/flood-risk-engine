require "rails_helper"

module FloodRiskEngine
  RSpec.describe ErrorsController, type: :controller do
    routes { Engine.routes }
    render_views
    describe "#show" do
      it "renders error templates when known" do
        get :show, params: { id: "401" }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:error_401)
      end

      it "renders generic when not known" do
        get :show, params: { id: "unknown" }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:error_generic)
      end
    end
  end
end

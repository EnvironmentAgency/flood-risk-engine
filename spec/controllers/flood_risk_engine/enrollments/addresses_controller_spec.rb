require "rails_helper"

module FloodRiskEngine
  module Enrollments
    RSpec.describe AddressesController, type: :controller do
      routes { Engine.routes }
      render_views
      let(:steps) { WorkFlow::Definitions.start }
      let(:step) { steps[1] }
      let(:next_step) { steps[2] }
      let(:enrollment) { FactoryBot.create(:enrollment, step: step) }
      let(:address) { FactoryBot.create(:address) }
      let(:postcode) { "S60 1BY" }
      let(:contact) { FactoryBot.create(:contact) }
      let(:addressable_type) { "FloodRiskEngine::Contact" }
      let(:addressable_id) { contact.id }
      let(:address_type) { :contact }

      describe "new action" do
        before do
          get(
            :new,
            params: {
              enrollment_id: enrollment,
              postcode: postcode,
              addressable_type: addressable_type,
              addressable_id: addressable_id,
              address_type: address_type
            }
          )
        end

        it "should render page sucessfully" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "create action" do
        before do
          expect_any_instance_of(AddressForm).to(
            receive(:validate).and_return(validation_result)
          )
          address # Calling address here, so that initiation doesn't get counted in Address.count change
          expect do
            post(
              :create,
              params: {
                enrollment_id: enrollment,
                postcode: postcode,
                addressable_type: addressable_type,
                addressable_id: addressable_id,
                address_type: address_type,
                flood_risk_engine_address: address.attributes.select do |attr, _value|
                  %i[premises street_address locality city].include? attr
                end
              }
            )
          end.to change { Address.count }.by(address_count_change)
        end

        context "on success" do
          let(:validation_result) { true }
          let(:address_count_change) { 1 }

          it "should redirect to the enrollment's next step on success" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, next_step)
            )
          end

          it "should create a new address" do
            expect(Address.last.postcode).to eq(postcode)
          end
        end

        context "failure" do
          let(:validation_result) { false }
          let(:address_count_change) { 0 }

          it "should redirect back to new with check for errors" do
            expect(response).to redirect_to(
              new_enrollment_address_path(
                enrollment,
                postcode: postcode,
                addressable_type: addressable_type,
                addressable_id: addressable_id,
                address_type: address_type,
                check_for_error: true
              )
            )
          end
        end
      end

      describe "edit action" do
        before do
          get :edit, params: { id: address, enrollment_id: enrollment }
        end

        it "should render page sucessfully" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "update action" do
        before do
          expect_any_instance_of(AddressForm).to(
            receive(:validate).and_return(validation_result)
          )
          put(
            :update,
            params: {
              id: address,
              enrollment_id: enrollment,
              flood_risk_engine_address: address.attributes
            }
          )
        end

        context "on success" do
          let(:validation_result) { true }

          it "should redirect to the enrollment's next step on success" do
            expect(response).to redirect_to(
              enrollment_step_path(enrollment, next_step)
            )
          end
        end

        context "failure" do
          let(:validation_result) { false }

          it "should redirect back to edit with check for errors" do
            expect(response).to redirect_to(
              edit_enrollment_address_path(enrollment, address, check_for_error: true)
            )
          end
        end
      end
    end
  end
end

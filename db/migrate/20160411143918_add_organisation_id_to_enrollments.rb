class AddOrganisationIdToEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :organisation_id, :integer, index: true
    add_foreign_key :flood_risk_engine_enrollments, :flood_risk_engine_organisations, column: :organisation_id
  end
end

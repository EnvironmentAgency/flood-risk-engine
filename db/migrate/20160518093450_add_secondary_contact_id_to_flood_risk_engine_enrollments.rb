class AddSecondaryContactIdToFloodRiskEngineEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :secondary_contact_id, :integer
    add_foreign_key(
      :flood_risk_engine_enrollments,
      :flood_risk_engine_contacts,
      column: :secondary_contact_id
    )
  end
end

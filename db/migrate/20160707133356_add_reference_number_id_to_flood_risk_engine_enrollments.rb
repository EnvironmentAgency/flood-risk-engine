class AddReferenceNumberIdToFloodRiskEngineEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :reference_number_id, :integer
    add_index :flood_risk_engine_enrollments, [:reference_number_id], :unique => true
  end
end

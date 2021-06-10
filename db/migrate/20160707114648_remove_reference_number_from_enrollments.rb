class RemoveReferenceNumberFromEnrollments < ActiveRecord::Migration[4.2]
  def up
    remove_index :flood_risk_engine_enrollments, [:reference_number]
    remove_column :flood_risk_engine_enrollments, :reference_number
  end

  def down
    add_column :flood_risk_engine_enrollments, :reference_number, :string, :limit => 12
    add_index :flood_risk_engine_enrollments, [:reference_number], :unique => true
  end
end

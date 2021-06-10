class RemoveFloodRiskEngineEnrollmentStatus < ActiveRecord::Migration[4.2]
  def up
    remove_column :flood_risk_engine_enrollments, :status
  end

  def down
    add_column :flood_risk_engine_enrollments, :status, :integer, default: 0, null: false
  end
end

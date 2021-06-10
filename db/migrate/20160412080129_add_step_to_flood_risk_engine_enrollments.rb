class AddStepToFloodRiskEngineEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :step, :string, limit: 50
  end
end

class AddStepHistoryToFloodRiskEngineEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :step_history, :text
  end
end

class AddDeregisteredReasonToFloodRiskEngineEnrollmentsExemptions < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments_exemptions, :deregister_reason, :string
  end
end

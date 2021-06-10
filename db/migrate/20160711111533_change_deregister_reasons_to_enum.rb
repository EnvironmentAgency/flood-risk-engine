class ChangeDeregisterReasonsToEnum < ActiveRecord::Migration[4.2]
  def up
    remove_column :flood_risk_engine_enrollments_exemptions, :deregister_reason
    add_column :flood_risk_engine_enrollments_exemptions, :deregister_reason, :integer
    add_index(
      :flood_risk_engine_enrollments_exemptions,
      :deregister_reason,
      name: "by_deregister_reason"
    )
  end

  def down
    remove_index :flood_risk_engine_enrollments_exemptions, name: "by_deregister_reason"
    remove_column :flood_risk_engine_enrollments_exemptions, :deregister_reason
    add_column :flood_risk_engine_enrollments_exemptions, :deregister_reason, :string
  end
end

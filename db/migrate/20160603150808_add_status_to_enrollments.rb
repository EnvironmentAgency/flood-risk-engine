class AddStatusToEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :status, :integer, default: 0, null: false
  end
end

class AddSubmittedAt < ActiveRecord::Migration[5.2]
  def change
    add_column :flood_risk_engine_enrollments, :submitted_at, :datetime, index: true
  end
end

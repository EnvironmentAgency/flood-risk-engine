class AddMissingEngineIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :flood_risk_engine_enrollments, :secondary_contact_id
  end
end

class RecreateExemptionsCodeNumberIndex < ActiveRecord::Migration[4.2]
  def up
    remove_index :flood_risk_engine_exemptions, :code_number
    add_index :flood_risk_engine_exemptions, :code_number, unique: false
  end
  def down
    remove_index :flood_risk_engine_exemptions, :code_number
    add_index :flood_risk_engine_exemptions, :code_number, unique: true
  end
end

class AddTokenToFloodRiskEngineAddresses < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_addresses, :token, :string
    add_index  :flood_risk_engine_addresses, :token, unique: true
  end
end

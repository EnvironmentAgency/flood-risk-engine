class AddUprnToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_addresses, :uprn, :string

    add_index :flood_risk_engine_addresses, :uprn

    change_column :flood_risk_engine_locations, :easting, :string
    change_column :flood_risk_engine_locations, :northing, :string

  end
end

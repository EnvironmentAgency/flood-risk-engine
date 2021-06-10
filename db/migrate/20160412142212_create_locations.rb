class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_locations do |t|
      t.integer :address_id, index: true
      t.float :easting
      t.float :northing
      t.string :grid_reference
      t.timestamps null: false
    end

    add_foreign_key :flood_risk_engine_locations,
                    :flood_risk_engine_addresses, column: :address_id
  end
end

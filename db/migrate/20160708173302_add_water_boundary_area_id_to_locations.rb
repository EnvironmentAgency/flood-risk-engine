class AddWaterBoundaryAreaIdToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_locations,
               :water_boundary_area_id,
               :integer,
               index: true
  end
end

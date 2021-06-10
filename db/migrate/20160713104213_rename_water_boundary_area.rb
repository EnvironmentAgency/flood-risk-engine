class RenameWaterBoundaryArea < ActiveRecord::Migration[4.2]
  def change
    rename_table :flood_risk_engine_water_boundary_areas,
                 :flood_risk_engine_water_management_areas

    rename_column :flood_risk_engine_locations,
                  :water_boundary_area_id,
                  :water_management_area_id
  end
end

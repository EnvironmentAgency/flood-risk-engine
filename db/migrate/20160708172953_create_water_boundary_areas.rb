class CreateWaterBoundaryAreas < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_water_boundary_areas do |t|
      # These names map to the names in the api output in geo lookups
      # code and long_name are currently the only columns we must have
      t.string  :code, null: false                # e.g. SHHRWG
      t.string  :long_name, null: false           # e.g. Shropshire Herefordshire Worcestershire and Gloucestershire
      t.string  :short_name                       # e.g. Shrops Heref Worcs and Glos
      t.integer :area_id                          # e.g. 31
      t.string  :area_name                        # e.g. West

      t.timestamps null: false
    end

    add_index :flood_risk_engine_water_boundary_areas,
              :code,
              unique: true,
              name: :fre_water_boundary_areas_code
  end
end

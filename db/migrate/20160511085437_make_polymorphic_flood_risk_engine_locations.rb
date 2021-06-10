class MakePolymorphicFloodRiskEngineLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_locations, :locatable_id, :integer
    add_column :flood_risk_engine_locations, :locatable_type, :string
    add_index(
      :flood_risk_engine_locations,
      [:locatable_id, :locatable_type],
      name: :by_locatable
    )

  end
end

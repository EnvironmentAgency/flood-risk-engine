class AddRiverCharacterFieldsToFloodRiskEngineEnrollmentsExemptions < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments_exemptions, :asset_found, :boolean, default: false
    add_column :flood_risk_engine_enrollments_exemptions, :salmonid_river_found, :boolean, default: false
  end
end

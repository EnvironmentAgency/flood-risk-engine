class CreateFloodRiskEnginePartners < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_partners do |t|
      t.integer :organisation_id, index: true
      t.integer :contact_id, index: true
      t.timestamps null: false
    end

    add_foreign_key(
      :flood_risk_engine_partners,
      :flood_risk_engine_organisations,
      column: :organisation_id
    )

    add_foreign_key(
      :flood_risk_engine_partners,
      :flood_risk_engine_contacts,
      column: :contact_id
    )
  end
end

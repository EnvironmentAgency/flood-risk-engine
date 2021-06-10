class CreateFloodRiskEngineOrganisations < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_organisations do |t|
      t.string :type
      t.string :name
      t.references :contact
      t.string :company_number

      t.timestamps null: false
    end
  end
end

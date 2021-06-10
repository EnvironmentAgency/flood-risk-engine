class CreateFloodRiskEngineAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_addresses do |t|
      t.string :premises, limit: 200
      t.string :street_address,     limit: 160
      t.string :locality,           limit: 70
      t.string :city,               limit: 30
      t.string :postcode,           limit: 8
      t.integer :county_province_id
      t.string :country_iso,        limit: 3
      t.integer :address_type,      default: 0, null: false
      t.string :organisation,       limit: 255, null: false, default: ''
      t.references :contact
      t.date :state_date
      t.string :blpu_state_code
      t.string :postal_address_code
      t.string :logical_status_code
      t.timestamps null: false
    end
  end
end

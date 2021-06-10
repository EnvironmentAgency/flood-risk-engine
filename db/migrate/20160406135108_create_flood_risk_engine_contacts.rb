class CreateFloodRiskEngineContacts < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_contacts do |t|
      t.integer :contact_type, null: false, default: 0
      t.integer :title, null: false, default: 0
      t.string :suffix
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :position
      t.string :email_address, index: true
      t.string :telephone_number
      t.integer :partnership_organisation_id
      t.timestamps null: false
    end

    add_foreign_key :flood_risk_engine_contacts,
                    :flood_risk_engine_organisations,
                    column: :partnership_organisation_id

    add_foreign_key :flood_risk_engine_addresses, :flood_risk_engine_contacts, column: :contact_id

    add_foreign_key :flood_risk_engine_organisations, :flood_risk_engine_contacts, column: :contact_id
  end
end

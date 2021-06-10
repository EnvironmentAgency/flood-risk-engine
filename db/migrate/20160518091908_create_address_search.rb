class CreateAddressSearch < ActiveRecord::Migration[4.2]

  def change

    create_table :flood_risk_engine_address_searches do |t|
      t.references  :enrollment,   null: false, index: true, unique: true
      t.string :postcode
      t.timestamps null: false
    end

    add_foreign_key :flood_risk_engine_address_searches, :flood_risk_engine_enrollments, column: :enrollment_id
  end
end

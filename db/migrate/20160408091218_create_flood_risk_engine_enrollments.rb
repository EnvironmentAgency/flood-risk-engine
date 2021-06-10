class CreateFloodRiskEngineEnrollments < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_enrollments do |t|
      # These columns are test only
      t.boolean :dummy_boolean
      t.string :dummy_string1
      t.string :dummy_string2

      # These are real
      t.integer :applicant_contact_id
      t.timestamps null: false
    end

    add_foreign_key :flood_risk_engine_enrollments,
                    :flood_risk_engine_contacts,
                    column: :applicant_contact_id
  end
end

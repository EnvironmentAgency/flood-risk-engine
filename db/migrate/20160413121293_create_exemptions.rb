class CreateExemptions < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_exemptions do |t|
      t.string  :code
      t.string  :summary
      t.text    :description

      t.timestamps null: false
    end

    create_table :flood_risk_engine_enrollments_exemptions do |t|
      t.references  :enrollment,      null: false
      t.references  :exemption,       null: false
      t.integer  :status,             default: 0
      t.datetime :expires_at
      t.datetime :valid_from
    end

    add_foreign_key :flood_risk_engine_enrollments_exemptions,
                    :flood_risk_engine_enrollments, column: :enrollment_id

    add_foreign_key :flood_risk_engine_enrollments_exemptions,
                    :flood_risk_engine_exemptions, column: :exemption_id

    add_index :flood_risk_engine_enrollments_exemptions,
              [:enrollment_id, :exemption_id],
              unique: true,
              name: 'fre_enrollments_exemptions_enrollment_id_exemption_id'
  end
end

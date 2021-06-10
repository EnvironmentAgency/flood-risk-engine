class AddMissingIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :flood_risk_engine_enrollments, :applicant_contact_id
    add_index :flood_risk_engine_enrollments, :organisation_id
    add_index :flood_risk_engine_enrollments, :site_address_id
    add_index :flood_risk_engine_contacts,
              :partnership_organisation_id,
              name: 'fre_contacts_partnership_organisation_id'
    add_index :flood_risk_engine_organisations, :type
  end
end

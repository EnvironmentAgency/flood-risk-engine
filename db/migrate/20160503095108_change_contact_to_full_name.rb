class ChangeContactToFullName < ActiveRecord::Migration[4.2]

  def up
    remove_column :flood_risk_engine_contacts, :first_name
    remove_column :flood_risk_engine_contacts, :last_name

    add_column :flood_risk_engine_contacts, :full_name, :string, limit: 255, null: false, default: ''
    add_index :flood_risk_engine_contacts, :full_name

    change_column :flood_risk_engine_contacts, :position, :string, limit: 255

    add_column :flood_risk_engine_enrollments, :correspondence_contact_id, :integer

    add_index :flood_risk_engine_enrollments,
              :correspondence_contact_id,
              name: 'fre_enrollments_correspondence_contact_id'
  end

  def down
    add_column :flood_risk_engine_contacts, :first_name
    add_column :flood_risk_engine_contacts, :last_name

    remove_column :flood_risk_engine_contacts, :full_name, :string
    remove_index :flood_risk_engine_contacts, :full_name

    change_column :flood_risk_engine_contacts, :position, :string

    remove_column :flood_risk_engine_enrollments, :correspondence_contact_id

    remove_index :flood_risk_engine_enrollments,  name: 'fre_enrollments_correspondence_contact_id'
  end

end

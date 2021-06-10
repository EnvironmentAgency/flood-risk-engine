class MakePolymorphicFloodRiskEngineAddresses < ActiveRecord::Migration[4.2]
  def up
    # Enrollments
    remove_foreign_key :flood_risk_engine_enrollments,
                    column: :site_address_id
    remove_index :flood_risk_engine_enrollments, :site_address_id
    remove_column :flood_risk_engine_enrollments, :site_address_id

    # Locations
    remove_index :flood_risk_engine_locations, :address_id
    remove_foreign_key :flood_risk_engine_locations,
                    column: :address_id
    remove_column :flood_risk_engine_locations, :address_id


    # Contacts
    remove_foreign_key :flood_risk_engine_addresses, column: :contact_id

    # Address
    remove_column :flood_risk_engine_addresses, :contact_id
    add_column :flood_risk_engine_addresses, :addressable_id, :integer
    add_column :flood_risk_engine_addresses, :addressable_type, :string
    add_index(
      :flood_risk_engine_addresses,
      [:addressable_id, :addressable_type],
      name: :by_addressable
    )
  end

  def down
    # Enrollments
    add_column :flood_risk_engine_enrollments, :site_address_id, :integer, index: true
    add_foreign_key :flood_risk_engine_enrollments,
                    :flood_risk_engine_addresses,
                    column: :site_address_id
    add_index :flood_risk_engine_enrollments, :site_address_id

    # Locations
    add_column :flood_risk_engine_locations, :address_id, :integer
    add_index :flood_risk_engine_locations, :address_id
    add_foreign_key :flood_risk_engine_locations,
                    :flood_risk_engine_addresses,
                    column: :address_id

    # Address
    remove_index :flood_risk_engine_addresses, name: :by_addressable
    remove_column :flood_risk_engine_addresses, :addressable_id
    remove_column :flood_risk_engine_addresses, :addressable_type
    add_column :flood_risk_engine_addresses, :contact_id, :integer

    # Contacts
    add_foreign_key :flood_risk_engine_addresses, :flood_risk_engine_contacts, column: :contact_id
  end
end

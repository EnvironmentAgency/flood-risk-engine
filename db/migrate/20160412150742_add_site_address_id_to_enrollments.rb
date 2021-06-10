class AddSiteAddressIdToEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :site_address_id, :integer, index: true
    add_foreign_key :flood_risk_engine_enrollments,
                    :flood_risk_engine_addresses,
                    column: :site_address_id
  end
end

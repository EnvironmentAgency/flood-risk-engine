class ChangeCompanyNumToRegNumber < ActiveRecord::Migration[4.2]
  def change

    remove_column :flood_risk_engine_organisations, :company_number

    add_column :flood_risk_engine_organisations, :registration_number, :string, limit: 12

    add_index :flood_risk_engine_organisations, :registration_number
  end
end

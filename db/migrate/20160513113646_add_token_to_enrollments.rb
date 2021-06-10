class AddTokenToEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :token, :string
    add_index  :flood_risk_engine_enrollments, :token, unique: true
  end
end

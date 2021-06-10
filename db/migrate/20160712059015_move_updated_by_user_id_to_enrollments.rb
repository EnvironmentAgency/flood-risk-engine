class MoveUpdatedByUserIdToEnrollments < ActiveRecord::Migration[4.2]
  def change

    # Migration moved here from BO so specs can be run but so existing install don't break
    # we replay as a later  migration

    if(column_exists?(:flood_risk_engine_enrollments, :updated_by_user_id))
      remove_column :flood_risk_engine_enrollments, :updated_by_user_id, :integer
    end

    add_column :flood_risk_engine_enrollments, :updated_by_user_id, :integer
    add_index :flood_risk_engine_enrollments, :updated_by_user_id
  end
end

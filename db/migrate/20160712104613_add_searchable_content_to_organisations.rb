class AddSearchableContentToOrganisations < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_organisations, :searchable_content, :text
    add_index :flood_risk_engine_organisations, :searchable_content
  end
end

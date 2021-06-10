class CreateFloodRiskEngineComments < ActiveRecord::Migration[4.2]
  def change
    create_table :flood_risk_engine_comments do |t|
      t.integer :user_id
      t.references :commentable, polymorphic: true, index: {:name => "commentable_idx"}
      t.text :content
      t.string :event

      t.timestamps null: false
    end
  end
end

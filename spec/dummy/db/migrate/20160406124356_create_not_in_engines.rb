class CreateNotInEngines < ActiveRecord::Migration[4.2]
  def change
    create_table :not_in_engines do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

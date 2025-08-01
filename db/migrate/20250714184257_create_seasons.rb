class CreateSeasons < ActiveRecord::Migration[8.0]
  def change
    create_table :seasons do |t|
      t.string :name
      t.bigint :external_ws_id
      t.references :competition, null: false, foreign_key: true
      t.integer :index

      t.timestamps
    end

    add_index :seasons, :external_ws_id, unique: true
  end
end

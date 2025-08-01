class CreateCompetitions < ActiveRecord::Migration[8.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.bigint :external_ws_id
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end

    add_index :competitions, :external_ws_id, unique: true
  end
end

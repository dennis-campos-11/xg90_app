class CreateCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.bigint :external_ws_id

      t.timestamps
    end

    add_index :countries, :external_ws_id, unique: true
  end
end

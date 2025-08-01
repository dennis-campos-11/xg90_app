class CreateFixtureListFields < ActiveRecord::Migration[8.0]
  def change
    create_table :fixture_list_fields do |t|
      t.references :fixture_list, null: false, foreign_key: true
      t.references :data_field, null: false, foreign_key: true
      t.jsonb :filters, default: {}
      t.integer :index

      t.timestamps
    end

    add_index :fixture_list_fields, [:fixture_list_id, :data_field_id], unique: true
  end
end

class CreateDataFields < ActiveRecord::Migration[8.0]
  def change
    create_table :data_fields do |t|
      t.string :code
      t.integer :field_type
      t.integer :half_type
      t.jsonb :settings, default: {}

      t.timestamps
    end
  end
end

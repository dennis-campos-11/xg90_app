class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :short_name
      t.bigint :external_ws_id
      t.string :primary_color
      t.string :text_color

      t.timestamps
    end

    add_index :teams, :external_ws_id, unique: true
  end
end

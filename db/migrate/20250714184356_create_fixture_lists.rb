class CreateFixtureLists < ActiveRecord::Migration[8.0]
  def change
    create_table :fixture_lists do |t|
      t.string :name
      t.integer :home_location
      t.integer :away_location
      t.integer :total_matches
      t.integer :season_index
      t.jsonb :sort, default: {}
      t.jsonb :settings, default: {}

      t.timestamps
    end
  end
end

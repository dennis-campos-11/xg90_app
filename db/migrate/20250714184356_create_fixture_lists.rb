class CreateFixtureLists < ActiveRecord::Migration[8.0]
  def change
    create_table :fixture_lists do |t|
      t.string :name
      t.integer :home_location
      t.integer :away_location
      t.integer :total_matches
      t.integer :season_index
      t.boolean :only_current_competition, default: false
      t.boolean :show_variance_against_competition, default: false

      t.timestamps
    end
  end
end

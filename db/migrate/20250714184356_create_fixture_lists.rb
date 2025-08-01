class CreateFixtureLists < ActiveRecord::Migration[8.0]
  def change
    create_table :fixture_lists do |t|
      t.integer :sample
      t.integer :home_location
      t.integer :away_location
      t.integer :season_index
      t.boolean :only_current_competition

      t.timestamps
    end
  end
end

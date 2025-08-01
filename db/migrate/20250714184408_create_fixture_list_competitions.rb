class CreateFixtureListCompetitions < ActiveRecord::Migration[8.0]
  def change
    create_table :fixture_list_competitions do |t|
      t.references :fixture_list, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true

      t.timestamps
    end

    add_index :fixture_list_competitions, [:fixture_list_id, :competition_id], unique: true
  end
end

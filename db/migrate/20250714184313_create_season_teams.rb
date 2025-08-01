class CreateSeasonTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :season_teams do |t|
      t.references :season, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :season_teams, [:season_id, :team_id], :unique => true
  end
end

class CreateTeamProcessedData < ActiveRecord::Migration[8.0]
  def change
    create_table :team_processed_data do |t|
      t.references :team, null: false, foreign_key: true
      t.references :competition, null: true, foreign_key: true
      t.integer :location
      t.integer :sample

      t.jsonb :stats, default: {}
      t.jsonb :facts, default: {}

      t.timestamps
    end
  end
end

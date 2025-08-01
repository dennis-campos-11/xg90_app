class CreateGroupedTeamsProcessedData < ActiveRecord::Migration[8.0]
  def change
    create_table :grouped_teams_processed_data do |t|
      t.references :competition, null: false, foreign_key: true
      t.boolean :only_current_competition
      t.integer :location
      t.integer :sample

      t.jsonb :stats, default: {}
      t.jsonb :facts, default: {}

      t.timestamps
    end
  end
end

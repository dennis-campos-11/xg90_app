class CreateFixtures < ActiveRecord::Migration[8.0]
  def change
    create_table :fixtures do |t|
      t.references :competition, foreign_key: true
      t.references :season, foreign_key: true
      t.belongs_to :home, foreign_key: { to_table: :teams }
      t.belongs_to :away, foreign_key: { to_table: :teams }
      t.bigint :external_ws_id
      t.datetime :starting_at
      t.integer :status

      t.jsonb :home_stats, default: {}
      t.jsonb :away_stats, default: {}
      t.jsonb :home_facts, default: {}
      t.jsonb :away_facts, default: {}

      t.timestamps
    end

    add_index :fixtures, :external_ws_id, unique: true
  end
end

class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :fixtures, :starting_at, name: "idx_fixtures_starting_at"
    add_index :fixtures, [:home_id, :starting_at], name: "idx_fixtures_home_id_starting_at"
    add_index :fixtures, [:away_id, :starting_at], name: "idx_fixtures_away_id_starting_at"
    add_index :fixtures, [:competition_id, :starting_at], name: "idx_fixtures_competition_id_starting_at"
    add_index :fixture_list_fields, :data_field_id, name: "idx_fixture_list_fields_data_field_id"
    add_index :fixture_list_competitions, :competition_id, name: "idx_fixture_list_fields_competition_id"
    add_index :data_fields, [:code, :field_type], name: "idx_data_fields_code_type"
  end
end

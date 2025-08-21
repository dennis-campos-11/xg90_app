class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :fixtures, [:status, :home_id]
    add_index :fixtures, [:status, :away_id]
    add_index :fixtures, [:season_id, :status]
    add_index :fixtures, :starting_at
    add_index :fixtures, [:home_id, :starting_at]
    add_index :fixtures, [:away_id, :starting_at]
    add_index :fixtures, [:competition_id, :starting_at]
    add_index :seasons, :index
    add_index :data_fields, :code
    add_index :data_fields, [:code, :field_type]
  end
end

class AddShowVarianceAgainstCompetitionToFixtureList < ActiveRecord::Migration[8.0]
  def change
    add_column :fixture_lists, :show_variance_against_competition, :boolean, default: false
  end
end

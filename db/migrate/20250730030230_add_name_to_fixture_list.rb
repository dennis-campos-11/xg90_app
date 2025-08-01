class AddNameToFixtureList < ActiveRecord::Migration[8.0]
  def change
    add_column :fixture_lists, :name, :string
  end
end

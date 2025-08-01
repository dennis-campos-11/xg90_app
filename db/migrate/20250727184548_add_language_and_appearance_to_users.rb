class AddLanguageAndAppearanceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :language, :string, default: 'en'
    add_column :users, :appearance, :string, default: 'light'
  end
end

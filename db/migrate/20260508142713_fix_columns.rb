class FixColumns < ActiveRecord::Migration[8.2]
  def change
    remove_column :users, :google_id
    add_column :users, :uid, :string

    add_index :users, :uid, unique: true
  end
end

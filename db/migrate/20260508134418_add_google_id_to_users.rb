class AddGoogleIdToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :google_id, :string
    add_index :users, :google_id, unique: true
  end
end

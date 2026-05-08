class AddImageUrlToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :image_url, :string
  end
end

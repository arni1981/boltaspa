class DropSolidCache < ActiveRecord::Migration[8.2]
  def change
    drop_table :solid_cache_entries
  end
end

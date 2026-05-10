class AddLockedToMatches < ActiveRecord::Migration[8.2]
  def change
    add_column :matches, :locked, :boolean, default: false
  end
end

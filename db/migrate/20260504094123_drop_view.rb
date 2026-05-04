class DropView < ActiveRecord::Migration[8.2]
  def change
    drop_view :standings_view
  end
end

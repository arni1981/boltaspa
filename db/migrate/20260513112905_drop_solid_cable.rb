class DropSolidCable < ActiveRecord::Migration[8.2]
  def change
    drop_table :solid_cable_messages
  end
end

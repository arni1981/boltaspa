class CreateVisits < ActiveRecord::Migration[8.2]
  def change
create_table :visits do |t|
      t.string :path
      t.string :user_agent
      t.string :remote_ip
      t.references :user, null: true # Optional: track logged-in users
      t.timestamps
    end
  end
end

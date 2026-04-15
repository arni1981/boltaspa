class CreateMemberships < ActiveRecord::Migration[8.2]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :league, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :memberships, %i[user_id league_id], unique: true
  end
end

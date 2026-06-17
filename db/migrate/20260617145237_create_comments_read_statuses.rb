class CreateCommentsReadStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :comments_read_statuses do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :league_competition, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :last_read_at, null: false
    end

    add_index :comments_read_statuses, %i[user_id league_competition_id], unique: true
  end
end

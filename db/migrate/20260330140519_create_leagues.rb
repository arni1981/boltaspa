class CreateLeagues < ActiveRecord::Migration[8.2]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :invite_code
      t.references :owner, null: false, foreign_key: { to_table: 'users', on_delete: :cascade }
      t.string :slug

      t.timestamps
    end
    add_index :leagues, :invite_code, unique: true
    add_index :leagues, :slug, unique: true
    add_index :leagues, %i[owner_id name], unique: true
  end
end

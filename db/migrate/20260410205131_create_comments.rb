class CreateComments < ActiveRecord::Migration[8.2]
  def change
    create_table :comments do |t|
      # Tie it to the specific League + Competition join
      t.references :league_competition, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.integer :matchday, null: false
      t.text :body, null: false

      t.timestamps
    end

    # The "Performance" Index:
    # This ensures that when you load a specific round's ticker,
    # the banter query is lightning fast.
    add_index :comments, %i[league_competition_id matchday]
  end
end

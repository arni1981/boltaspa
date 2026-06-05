class AddMissingToRankings < ActiveRecord::Migration[8.1]
  def change
    change_table :season_rankings, bulk: true do |t|
      t.integer :won, null: false, default: 0
      t.integer :draw, null: false, default: 0
      t.integer :lost, null: false, default: 0
    end
  end
end

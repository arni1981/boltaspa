class CreateSeasonRankings < ActiveRecord::Migration[8.1]
  def change
    create_table :season_rankings do |t|
      t.references :season, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.string :stage, null: false
      t.string :group

      t.integer :position, null: false
      t.integer :played_games, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.integer :goals_for, null: false, default: 0
      t.integer :goals_against, null: false, default: 0
      t.integer :goal_difference, null: false, default: 0

      t.timestamps
    end

    add_index :season_rankings,
              %i[season_id competition_id team_id stage],
              unique: true
  end
end

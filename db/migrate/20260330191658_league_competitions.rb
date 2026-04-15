class LeagueCompetitions < ActiveRecord::Migration[8.2]
  def change
    # 1. Links a League to a specific Competition (e.g., "The Sunday Club" -> "Premier League")
    create_table :league_competitions do |t|
      t.references :league, null: false, foreign_key: { on_delete: :cascade }
      t.references :competition, null: false, foreign_key: { on_delete: :cascade }
      t.references :season, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :league_competitions, %i[league_id competition_id season_id], unique: true

    # 2. The specific teams selected for that specific League-Competition pair
    create_table :league_competition_teams do |t|
      t.references :league_competition, null: false, foreign_key: { on_delete: :cascade }
      t.references :team, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :league_competition_teams, %i[league_competition_id team_id], unique: true
  end
end

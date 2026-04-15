class CreateCompetitionTeams < ActiveRecord::Migration[8.2]
  def change
    create_table :competition_teams do |t|
      t.references :competition, null: false, foreign_key: { on_delete: :cascade }
      t.references :team, null: false, foreign_key: { on_delete: :cascade }
      t.integer :season, null: false
      t.timestamps
    end

    add_index :competition_teams, %i[competition_id team_id season], unique: true
  end
end

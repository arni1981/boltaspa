class LeagueCompetition < ApplicationRecord
  belongs_to :league
  belongs_to :competition
  belongs_to :season

  has_many :league_competition_teams
  has_many :teams, through: :league_competition_teams
  has_many :standings
  has_many :comments

  delegate :year, to: :season, prefix: false

  # Helper to find matches relevant to this specific tournament setup
  def relevant_matches
    Match.where(season_id: season_id)
         .where('home_team_id IN (?) OR away_team_id IN (?)', team_ids, team_ids)
  end
end

class LeagueCompetition < ApplicationRecord
  belongs_to :league
  belongs_to :competition
  belongs_to :season

  has_many :league_competition_teams
  has_many :teams, through: :league_competition_teams
  has_many :standings, -> { order(total_points: :desc) }
  has_many :comments

  delegate :year, :current_matchday, to: :season, prefix: false

  def matches_for(matchday)
    competition
      .matches
      .where(season: season, matchday: matchday)
      .includes(:home_team, :away_team)
      .order(:kickoff_at)
  end
end

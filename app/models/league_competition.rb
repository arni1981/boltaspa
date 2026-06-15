class LeagueCompetition < ApplicationRecord
  belongs_to :league
  belongs_to :competition
  belongs_to :season

  has_many :league_competition_teams
  has_many :teams, through: :league_competition_teams
  has_many :standings, -> { joins(:user).order('standings_views.rank') }
  has_many :comments

  delegate :year, :current_matchday, to: :season, prefix: false

  def matches_for(day)
    competition
      .matches
      .where(season: season, kickoff_at: day.all_day)
      .includes(:home_team, :away_team)
      .order(:kickoff_at)
  end
end

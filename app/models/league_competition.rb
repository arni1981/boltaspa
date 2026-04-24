class LeagueCompetition < ApplicationRecord
  belongs_to :league
  belongs_to :competition
  belongs_to :season

  has_many :league_competition_teams
  has_many :teams, through: :league_competition_teams
  has_many :standings
  has_many :comments

  delegate :year, to: :season, prefix: false

  def leaderboard
    Standing.where(league_id: league.id,
                   competition_id: competition.id,
                   season_id: season.id)
            .order(total_points: :desc)
            .includes(:user)
  end

  def matches_for(matchday)
    competition
      .matches
      .where(season: season, matchday: matchday)
      .includes(:home_team, :away_team)
      .order(:kickoff_at)
  end
end

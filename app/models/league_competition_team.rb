class LeagueCompetitionTeam < ApplicationRecord
  belongs_to :team
  belongs_to :league_competition
end

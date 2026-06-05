class SeasonRankingsJob < ApplicationJob
  queue_as :default

  def perform(competition_code, season)
    response = football_data("#{competition_code}/standings")

    competition = Competition.find_by_code(competition_code)
    season_record = Season.find_by_external_id(response.dig('season', 'id'))

    team_map = Team.pluck(:external_id, :id).to_h

    response['standings'].each do |standing_block|
      standing_block['table'].each do |row|
        external_team_id = row.dig('team', 'id')
        next if team_map[external_team_id].nil?

        SeasonRanking.find_or_initialize_by(
          season_id: season_record.id,
          competition_id: competition.id,
          team_id: team_map[external_team_id],
          stage: standing_block['stage']
        ).tap do |ranking|
          ranking.group           = standing_block['group']&.split&.map(&:upcase)&.join('_')
          ranking.position        = row['position']
          ranking.played_games    = row['playedGames']
          ranking.points          = row['points']
          ranking.goals_for       = row['goalsFor']
          ranking.goals_against   = row['goalsAgainst']
          ranking.goal_difference = row['goalDifference']
          ranking.won = row['won']
          ranking.draw = row['draw']
          ranking.lost = row['lost']

          ranking.save
        end
      end
    end
  end
end

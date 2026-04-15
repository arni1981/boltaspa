class MatchesJob < ApplicationJob
  queue_as :default

  def perform(competition_code, season)
    response = football_data("#{competition_code}/matches?season=#{season}")

    competition_id = Competition.find_by_code(competition_code).id
    team_map = Team.pluck(:external_id, :id).to_h

    response['matches']&.each do |m|
      next if team_map[m.dig('homeTeam', 'id')].nil?
      next if team_map[m.dig('awayTeam', 'id')].nil?

      Match.find_or_initialize_by(external_id: m['id']).tap do |match|
        match.competition_id = competition_id
        match.home_team_id   = team_map[m.dig('homeTeam', 'id')]
        match.away_team_id   = team_map[m.dig('awayTeam', 'id')]
        match.kickoff_at     = m['utcDate']
        match.status         = m['status']
        match.home_score     = m.dig('score', 'fullTime', 'home')
        match.away_score     = m.dig('score', 'fullTime', 'away')
        match.matchday       = m['matchday']
        match.season         = Season.find_by_external_id(m.dig('season', 'id'))

        match.save!
      end
    end
  end
end

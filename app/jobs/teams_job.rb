class TeamsJob < ApplicationJob
  queue_as :default

  def perform(competition_code, season)
    response = football_data("#{competition_code}/teams?season=#{season}")

    competition_id = Competition.find_by_code(competition_code).id

    response["teams"]&.each do |data|
      team = Team.find_or_initialize_by(external_id: data["id"]).tap do |team|
        team.name       = data["name"]
        team.short_name = data["shortName"]
        team.tla        = data["tla"]
        team.crest_url  = data["crest"]

        team.save!
      end

      CompetitionTeam.find_or_create_by(
        competition_id: competition_id,
        team_id: team.id,
        season: season
      )
    end
  end
end

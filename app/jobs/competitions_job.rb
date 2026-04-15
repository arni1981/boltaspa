class CompetitionsJob < ApplicationJob
  queue_as :default

  def perform(competition_code)
    response = football_data(competition_code)

    competition = Competition.find_or_initialize_by(external_id: response['id']).tap do |competition|
      competition.name = response['name']
      competition.code = response['code']
      competition.emblem = response['emblem']

      competition.save!
    end

    response['seasons'].each do |data_season|
      Season.find_or_initialize_by(external_id: data_season['id']).tap do |season|
        season.start_date = data_season['startDate']
        season.end_date = data_season['endDate']
        season.current_matchday = data_season['currentMatchday']
        season.winner = data_season['winner']
        season.competition = competition
        season.current = data_season['id'] == response.dig('currentSeason', 'id')

        season.save!
      end
    end
  end
end

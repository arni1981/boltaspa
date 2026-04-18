namespace :api do
  task matches: :environment do
    competitions_seasons.each do |competition_code, season|
      MatchesJob.perform_now(competition_code, season)
    end
  end

  task competitions: :environment do
    competitions_seasons.each do |competition_code, season|
      CompetitionsJob.perform_now(competition_code)
    end
  end

  task teams: :environment do
    competitions_seasons.each do |competition_code, season|
      TeamsJob.perform_now(competition_code, season)
    end
  end

  task all: :environment do
    competitions_seasons.each do |competition_code, season|
      CompetitionsJob.perform_now(competition_code)
      TeamsJob.perform_now(competition_code, season)
      MatchesJob.perform_now(competition_code, season)
    end
  end

  def competitions_seasons
    # %w[PL WC].product((2025..Time.current.year).to_a)
    [['PL', 2025], ['WC', 2026]]
  end
end

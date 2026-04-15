namespace :api do
  task matches: :environment do
    competitions.each do |competition_code|
      MatchesJob.perform_now(competition_code, 2025)
    end
  end

  task competitions: :environment do
    competitions.each do |competition_code|
      CompetitionsJob.perform_now(competition_code)
    end
  end

  task teams: :environment do
    competitions.each do |competition_code|
      TeamsJob.perform_now(competition_code, 2025)
    end
  end

  task all: :environment do
    competitions.each do |competition_code|
      CompetitionsJob.perform_now(competition_code)
      TeamsJob.perform_now(competition_code, 2025)
      MatchesJob.perform_now(competition_code, 2025)
    end
  end

  def competitions
    # Competition.pluck(:code)
    %w[PL CL]
  end
end

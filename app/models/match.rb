class Match < ApplicationRecord
  belongs_to :competition
  belongs_to :season

  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'

  scope :upcoming, -> { where.not(status: 'FINISHED').where(kickoff_at: Time.current...) }
  scope :with_results, -> { where(status: ['FINISHED']) }
  scope :ordered, -> { order(:kickoff_at) }

  def finished?
    status == 'FINISHED'
  end

  def live?
    # Catching all "active" states
    %w[IN_PLAY].include?(status)
  end

  def minute
    15
  end

  def short_name_string(separator = ' - ')
    "#{home_team.short_name}#{separator}#{away_team.short_name}"
  end

  def tla_string(separator = ' - ')
    "#{home_team.tla}#{separator}#{away_team.tla}"
  end

  after_save_commit do
    MatchPointsCalculatorJob.perform_later(id)
  end

  def self.upcoming_matches(competition_ids, window: 10, minimum: 5)
    cache_key = "competition_window/#{Array(competition_ids).sort.join('-')}/#{window}/#{minimum}"

    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      match_ids = find_by_sql([
                                'SELECT id FROM upcoming_matches_func(ARRAY[?], ?, ?)',
                                Array(competition_ids),
                                window,
                                minimum
                              ]).map(&:id)

      Match.where(id: match_ids)
           .includes(:home_team, :away_team, :competition)
           .ordered
    end
  end
end

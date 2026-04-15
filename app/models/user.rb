class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :memberships
  has_many :leagues, through: :memberships, source: :league
  has_many :league_competitions, through: :leagues
  has_many :competitions, -> { distinct }, through: :league_competitions
  has_many :matches, -> { distinct }, through: :competitions
  has_many :predictions

  validates :name,
            presence: true,
            length: { minimum: 2, maximum: 60 },
            allow_blank: true

  # after_create do
  #   CreateContactJob.perform_later(email)
  # end
  #

  def upcoming_matches
    Match.upcoming_matches(competitions)
         .includes(:home_team, :away_team, :competition)
  end

  def incomplete_matches
    # Use the user's latest prediction update to automatically expire the cache
    last_change = predictions.maximum(:updated_at).to_i
    cache_key = "user/#{id}/incomplete/#{match_ids.hash}/#{last_change}"

    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      incomplete_ids = Match.find_by_sql([
                                           'SELECT id FROM user_incomplete_matches(?, ARRAY[?]::BIGINT[])',
                                           id,
                                           upcoming_matches.ids
                                         ]).map(&:id)

      Match.where(id: incomplete_ids)
    end
  end
end

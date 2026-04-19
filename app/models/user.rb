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
    Match.upcoming_matches(competitions.ids)
         .includes(:home_team, :away_team, :competition)
  end
end

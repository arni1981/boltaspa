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

  def gravatar_url(size: 80)
    gravatar_id = Digest::MD5.hexdigest(email_address.downcase)
    "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mp"
  end

  def upcoming_matches
    Match.upcoming_matches(competitions.ids)
         .includes(:home_team, :away_team, :competition)
  end

  def predictions_map(matches)
    predictions.where(match_id: matches.map(&:id)).index_by(&:match_id)
  end

  def unfinished_matches(matches)
    matches.where.not(id: predictions.select(:match_id))
  end

  def self.from_omniauth(request)
    user = User.find_by(google_id: request[:uid])

    unless user
      user = User.find_or_create_by(email_address: request[:info][:email])
      user.update(
        google_id: request[:uid],
        name: request[:info][:name]
      )
    end

    user
  end
end

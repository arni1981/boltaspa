class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :league_competition

  validates :body, presence: true, length: { maximum: 280 } # Twitter-length for focus
  validates :matchday, presence: true

  # Scopes for the "Pallborðið" view
  scope :for_matchday, ->(day) { where(matchday: day) }
  scope :chronological, -> { order(created_at: :asc) }

  after_create_commit lambda {
    broadcast_refresh_later_to league_competition
  }
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :league_competition

  validates :body, presence: true, length: { maximum: 280 } # Twitter-length for focus
  validates :matchday, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  after_commit on: %i[create destroy] do
    broadcast_replace_later_to(
      league_competition,
      :comments,
      target: ActionView::RecordIdentifier.dom_id(league_competition, :comments_panel),
      partial: 'comments/panel',
      locals: { league_competition: league_competition }
    )
  end
end

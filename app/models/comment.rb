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

    league_competition.members.each do |member|
      # next if member.id == Current.user.id

      broadcast_replace_later_to(
        "unread_messages_#{self.league_competition.signed_id}",
        target: ActionView::RecordIdentifier.dom_target(self.league_competition, :unread_dot),
        partial: 'league_competitions/unread_dot',
        locals: { league_competition: self.league_competition, unread_messages: true, user: member }
      )
    end
  end
end

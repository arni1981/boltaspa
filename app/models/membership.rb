class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :league, touch: true

  validates :user_id, uniqueness: { scope: :league_id, message: "already in this league" }
end

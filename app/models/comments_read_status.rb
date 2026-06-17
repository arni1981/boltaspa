class CommentsReadStatus < ApplicationRecord
  belongs_to :user
  belongs_to :league_competition
end

class SeasonRanking < ApplicationRecord
  belongs_to :team
  belongs_to :season
  belongs_to :competition
end

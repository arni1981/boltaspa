class Competition < ApplicationRecord
  has_many :matches
  has_many :seasons

  has_one :current_season, -> { where(current: true) }, class_name: 'Season'

  def to_param
    code
  end
end

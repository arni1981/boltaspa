class Season < ApplicationRecord
  belongs_to :competition, touch: true

  has_many :matches

  # attr_readonly :year
end

class Season < ApplicationRecord
  belongs_to :competition

  has_many :matches

  attr_readonly :year
end

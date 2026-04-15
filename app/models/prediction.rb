class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validate :match_not_started
  validates :home_guess, :away_guess,
            presence: true,
            numericality: { only_integer: true, in: 0..4 }

  def match_not_started
    return unless match.kickoff_at < 10.minutes.from_now

    errors.add(:base, 'Spár eru læstar 10 mín fyrir leik.')
  end
end

class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match
  has_one :home_team, through: :match
  has_one :away_team, through: :match

  validate :match_not_started

  validates :home_guess, :away_guess,
            presence: true

  validates :home_guess, :away_guess,
            numericality: { only_integer: true, in: 0..5 },
            allow_nil: true

  def match_not_started
    return unless match.kickoff_at < Match::PREDICTION_LOCK_WINDOW.from_now

    errors.add(:base, I18n.t('activerecord.attributes.prediction.kickoff_at_validation'))
  end
end

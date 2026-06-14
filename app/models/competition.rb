class Competition < ApplicationRecord
  has_many :matches
  has_many :seasons

  has_one :current_season, -> { where(current: true) }, class_name: 'Season'

  def to_param
    code
  end

  def next_matchday(from_date = Time.current)
    self.matches.where(kickoff_at: from_date.tomorrow...).limit(1).pluck('min(kickoff_at::date)').first
  end

  def prev_matchday(from_date = Time.current)
    self.matches.where(kickoff_at: ...from_date).limit(1).pluck('max(kickoff_at::date)').first
  end

  def localized_name(with_year: true)
    if with_year
      I18n.t(code.downcase, scope: 'competitions.names', year: current_season.year,
                            year_end: current_season.year + 1)
    else
      I18n.t(code.downcase, scope: 'competitions.names', year: nil, year_end: nil)
    end
  end
end

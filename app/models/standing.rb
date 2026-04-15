class Standing < ApplicationRecord
  # self.table_name = 'standings_view_materialized'
  self.table_name = 'standings_view'

  belongs_to :user
  belongs_to :league_competition
  belongs_to :season
  delegate :competition, :season, to: :league_competition

  def readonly?
    true
  end

  def recent_form
    full_form_array.last(5)
  end
end

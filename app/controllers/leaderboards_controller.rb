class LeaderboardsController < ApplicationController
  def show
    @league_competition = Current.user.leagues.find_by_slug!(params[:league_slug])
                                 .league_competitions.joins(:competition, :season)
                                 .find_by!(competitions: { code: params[:competition_code] },
                                           seasons: { year: params[:year] })

    @matchdays = (1..35).to_a
  end
end

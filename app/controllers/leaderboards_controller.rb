class LeaderboardsController < ApplicationController
  def show
    @league_competition = Current.user.leagues.find_by_slug!(params[:league_slug])
                                 .league_competitions.joins(:competition, :season)
                                 .find_by!(competitions: { code: params[:competition_code] },
                                           seasons: { year: params[:year] })

    @stages = @league_competition.competition.matches.pluck('distinct stage')

    @active_stage = params[:stage]
  end
end

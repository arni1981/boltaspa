class LeagueCompetitionsController < ApplicationController
  def show
    @league_competition = Current.user.leagues.find_by_slug!(params[:league_slug])
                                 .league_competitions.joins(:competition, :season)
                                 .find_by!(competitions: { code: params[:competition_code] },
                                           seasons: { year: params[:year] })

    @date = Time.zone.parse(params.fetch(:date, Time.zone.today.to_s))

    @matches = @league_competition.matches_for(@date)

    @active_tab = params.fetch(:tab, 'standings')

    return unless params[:compare_user_id].present?

    @compare_user = @league_competition.league
                                       .members.find(params[:compare_user_id])
  end
end

class LeagueCompetitionsController < ApplicationController
  def show
    @league_competition = Current.user.leagues.find_by_slug!(params[:league_slug])
                                 .league_competitions.joins(:competition, :season)
                                 .find_by!(competitions: { code: params[:competition_code] },
                                           seasons: { year: params[:year] })

    # Logic to find the current round
    @current_matchday = params.fetch(:matchday, @league_competition.season.current_matchday)

    @matches = @league_competition.matches_for(@current_matchday)

    @grouped_matches = @matches.group_by { |m| m.kickoff_at.to_date }

    @compare_user = @league.members.find(params[:compare_user_id]) if params[:compare_user_id].present?
  end
end

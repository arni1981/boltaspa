class LeagueCompetitionsController < ApplicationController
  def show
    @league = Current.user.leagues.find_by_slug(params[:league_slug])
    @competition = Competition.find_by(code: params[:competition_code])

    @league_competition = @league.league_competitions
                                 .find_by(competition: @competition)

    # Logic to find the current round
    @current_matchday = if params[:matchday].present?
                          params[:matchday].to_i
                        else
                          @competition.current_season.current_matchday
                        end

    @matches = @competition
               .matches
               .where(matchday: @current_matchday)
               .order(:kickoff_at)
               .includes(:home_team, :away_team)

    @grouped_matches = @matches.group_by { |m| m.kickoff_at.to_date }

    @predictions_map = Current.user.predictions
                              .where(match_id: @matches.map(&:id))
                              .index_by(&:match_id)

    return unless params[:compare_user_id].present?

    @compare_user = @league.members.find(params[:compare_user_id])
    @compare_predictions_map = @compare_user.predictions
                                            .where(match_id: @matches.map(&:id))
                                            .index_by(&:match_id)
  end
end

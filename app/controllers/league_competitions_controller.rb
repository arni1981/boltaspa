class LeagueCompetitionsController < ApplicationController
  def show
    @league = Current.user.leagues.find_by_slug(params[:league_slug])
    @competition = Competition.find_by(code: params[:competition_code])

    @league_competition = @league.league_competitions.find_by(competition: Competition.find_by(code: params[:competition_code]))

    # Logic to find the current round
    @current_matchday = params[:matchday].present? ? params[:matchday].to_i : @competition.current_season.current_matchday
    @prev_matchday = [@current_matchday - 1, 1].max
    @next_matchday = [@current_matchday + 1, 38].min

    @matches = @competition
               .matches
               .where(matchday: @current_matchday)
               .order(:kickoff_at)
               .includes(:home_team, :away_team)

    @leaderboard = Standing.where(league_id: @league.id,
                                  competition_id: @league_competition.competition,
                                  season_id: @league_competition.season_id)
                           .order(total_points: :desc)
                           .includes(:user)

    @predictions_map = Current.user.predictions
                              .where(match_id: @matches.map(&:id))
                              .index_by(&:match_id)

    @comments = @league_competition.comments.where(matchday: @current_matchday).order(id: :desc)

    return unless params[:compare_user_id].present?

    @compare_user = @league.members.find(params[:compare_user_id])
    @compare_predictions_map = @compare_user.predictions
                                            .where(match_id: @matches.map(&:id))
                                            .index_by(&:match_id)
  end
end

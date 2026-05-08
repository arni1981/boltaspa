class CommentsController < ApplicationController
  def create
    @lc = LeagueCompetition.find(params[:league_competition_id])

    @lc.comments.create(
      matchday: params.dig(:comment, :matchday),
      body: params.dig(:comment, :body),
      user_id: Current.user.id
    )

    redirect_to league_competition_by_year_path(
      league_id: @lc.league.slug,
      competition_code: @lc.competition.code,
      year: @lc.year,
      compare_user_id: params.dig(:comment, :compare_user_id),
      matchday: params.dig(:comment, :matchday)
    )
  end
end

class CommentsController < ApplicationController
  before_action :set_league_competition
  def index
  end

  def create
    @league_competition.comments.create!(
      matchday: 0, # deprecated, will remove soon
      body: params.dig(:comment, :body),
      user_id: Current.user.id
    )

    head 201
  end

  private

  def set_league_competition
    @league_competition =
      Current.user.league_competitions.find(params[:league_competition_id])
  end
end

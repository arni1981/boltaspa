class PredictionsController < ApplicationController
  def index
    redirect_to onboarding_path and return if Current.user.leagues.none?

    @upcoming_matches = Current.user.upcoming_matches
    @predictions_map = Current.user.predictions_map(@upcoming_matches)
    @unfinished_matches = @upcoming_matches.reject { |m| @predictions_map[m.id]&.home_guess.present? }
  end

  def create
    score = params[:score_string]
    prediction = Current.user.predictions.find_or_initialize_by(match_id: params[:match_id])

    home, away = score.split('-')
    prediction.update!(home_guess: home, away_guess: away)

    @match = Match.find(params[:match_id])

    @upcoming_matches = Current.user.upcoming_matches
    @predictions_map = Current.user.predictions_map(@upcoming_matches)
    @unfinished_matches = @upcoming_matches.reject { |m| @predictions_map[m.id]&.home_guess.present? }
  end
end

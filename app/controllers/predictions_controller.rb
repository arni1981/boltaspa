class PredictionsController < ApplicationController
  def index
    redirect_to onboarding_path and return if Current.user.leagues.none?

    @upcoming_matches = Current.user.upcoming_matches
    @predictions_map = Current.user.predictions_map(@upcoming_matches)
    @unfinished_matches = Current.user.unfinished_matches(@upcoming_matches)
  end

  def create
    prediction = Current.user.predictions.find_or_initialize_by(match_id: params[:match_id])

    home, away = params[:score_string].split('-')

    if prediction.update(home_guess: home, away_guess: away)
      head :ok
    else
      flash[:error] = prediction.errors.full_messages.to_sentence
      redirect_to predictions_path
    end
  end
end

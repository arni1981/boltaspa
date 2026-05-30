class PredictionsController < ApplicationController
  def index
    redirect_to onboarding_path and return if Current.user.leagues.none?

    @upcoming_matches = Current.user.upcoming_matches
    @predictions_map = Current.user.predictions_map(@upcoming_matches)
    @unfinished_matches = Current.user.unfinished_matches(@upcoming_matches)
  end

  def create
    @updated_match_ids = []
    @errors = []
    @predictions = Current.user.predictions.where(match_id: prediction_params.keys).includes(:match)

    prediction_params.each do |match_id, score_string|
      home = score_string[:home_guess]
      away = score_string[:away_guess]

      next if home.blank? && away.blank?

      home ||= 0
      away ||= 0

      # Locate in memory or initialize a brand new prediction object
      prediction = @predictions.find do |p|
        p.match_id == match_id
      end || Current.user.predictions.find_or_initialize_by(match_id: match_id)

      prediction.assign_attributes(home_guess: home, away_guess: away)
      is_changed = prediction.changed?

      if prediction.save
        @updated_match_ids << match_id.to_i if is_changed
      else
        prediction.reload
        @errors << prediction
      end
    end

    # Only fetch predictions map for matches that successfully committed to the DB
    @predictions_map = Current.user.predictions_map(Match.where(id: @updated_match_ids))

    @matches = Match.where(id: prediction_params.keys)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to predictions_path }
    end
  end

  def prediction_params
    params.fetch(:predictions, {})
  end
end

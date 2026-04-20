class PredictionsController < ApplicationController
  def index
    redirect_to onboarding_path and return if Current.user.leagues.none?

    init_view_data
  end

  def create
    @updated_match_ids = []

    ActiveRecord::Base.transaction do
      params[:predictions].each do |match_id, data|
        score = data[:score_string]
        prediction = Current.user.predictions.find_or_initialize_by(match_id: match_id)

        if score.blank?
          prediction&.destroy
        else
          home, away = score.split('-')
          prediction.assign_attributes(home_guess: home, away_guess: away)

          if prediction.changed?
            prediction.save!
            @updated_match_ids << match_id
          end
        end
      end
    end

    @updated_matches = Match.where(id: @updated_match_ids)
    init_view_data
  end

  def predictions_map
    @predictions_map ||= Current.user.predictions
                                .where(match_id: Current.user.upcoming_matches.map(&:id))
                                .index_by(&:match_id)
  end

  def init_view_data
    @upcoming_matches = Current.user.upcoming_matches
    @predictions_map = predictions_map
  end
end

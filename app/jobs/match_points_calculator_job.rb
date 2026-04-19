class MatchPointsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(match_id)
    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE predictions
        SET points_won = calculate_prediction_points(m.home_score, m.away_score, predictions.home_guess, predictions.away_guess),
            updated_at = NOW()
      FROM matches m
      WHERE predictions.match_id = m.id
      and m.status in ('FINISHED', 'IN_PLAY', 'PAUSED')
      and m.id = #{match_id};
    SQL

    Match.find(match_id).broadcast_refresh
  end
end

class MatchPointsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(match_id)
    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE predictions
        SET points_won = CASE
                           WHEN predictions.home_guess = m.home_score
                               AND predictions.away_guess = m.away_score
                               THEN 3

                           WHEN SIGN(predictions.home_guess - predictions.away_guess)
                               = SIGN(m.home_score - m.away_score)
                               THEN 1

                           ELSE 0
          END,
          updated_at = NOW()
      FROM matches m
      WHERE predictions.match_id = m.id
      and m.status in ('FINISHED', 'IN_PLAY')
      and m.id = #{match_id};
    SQL

    Match.find(match_id).broadcast_refresh
  end
end

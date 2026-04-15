namespace :simulate do
  desc 'Simulates predictions for all users for the Premier League (competition_id = 3)'
  task predictions: :environment do
    ActiveRecord::Base.connection.execute <<~SQL
      alter table predictions disable trigger trg_prediction_lockout;
      delete from predictions;
      INSERT INTO predictions (user_id, match_id, home_guess, away_guess, created_at, updated_at)
      SELECT u.id,
             m.id,
             floor(random() * 5), -- Random 0-4
             floor(random() * 5),
             now(),
             now()
      FROM users u
               CROSS JOIN matches m
      ON CONFLICT (user_id, match_id)
          DO NOTHING;
      alter table predictions enable trigger trg_prediction_lockout;
    SQL
  end

  desc 'Calculates points for all predictions'
  task calc_points: :environment do
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
        and m.status = 'FINISHED'
    SQL
  end
end

class AddPointsFunction < ActiveRecord::Migration[8.2]
  def change
    execute <<~SQL
            CREATE OR REPLACE FUNCTION calculate_prediction_points(
          home_score INT,
          away_score INT,
          home_guess INT,
          away_guess INT
      ) RETURNS INT AS
      $$
      SELECT CASE
                 -- 1. Exact Match Jackpot (The Bullseye)
                 WHEN home_score = home_guess AND away_score = away_guess THEN 25

                 ELSE (
                     -- 2. Outcome Check (10 points if the right team won or it was a draw)
                     CASE
                         WHEN (home_score > away_score AND home_guess > away_guess) OR
                              (home_score < away_score AND home_guess < away_guess) OR
                              (home_score = away_score AND home_guess = away_guess)
                             THEN 10
                         ELSE 0
                         END +

                         -- 3. The "Spirit" Bonus Math
                         -- Rewards how close the "vibe" of the prediction was to reality
                     ROUND(GREATEST(0, 10 -
                                       ((ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 1.5) -
                                       (ABS((home_score - away_score) - (home_guess - away_guess)) * 0.5)
                           ))::INT
                     )
                 END;
      $$ LANGUAGE SQL IMMUTABLE;
    SQL
  end
end

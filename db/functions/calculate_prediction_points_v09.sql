CREATE OR REPLACE FUNCTION public.calculate_prediction_points(
  home_score  integer,
  away_score  integer,
  home_guess  integer,
  away_guess  integer
)
RETURNS integer
LANGUAGE sql
IMMUTABLE
AS
$function$
WITH vars AS (
  SELECT
    home_score,
    away_score,
    home_guess,
    away_guess,
    SIGN(home_score - away_score)  AS actual_sign,
    SIGN(home_guess - away_guess)  AS guess_sign
)
SELECT
  CASE
    -- 1. Exact score
    WHEN home_score = home_guess
     AND away_score = away_guess
    THEN 25

    -- 2. Correct outcome (win/draw/loss)
    WHEN actual_sign = guess_sign THEN
      10
      +
      GREATEST(
        0,
        10
        - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2
        - ABS((home_score - away_score) - (home_guess - away_guess))
      )

    -- 3. Predicted draw, actual winner → small mercy reward
    WHEN guess_sign = 0 AND actual_sign != 0 THEN
      GREATEST(
        0,
        4
        - (ABS(home_score - home_guess) + ABS(away_score - away_guess))
      )

    -- 4. Wrong winner → zero
    ELSE 0
  END
FROM vars;
$function$;

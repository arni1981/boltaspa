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
    SIGN(home_score - away_score) AS actual_sign,
    SIGN(home_guess - away_guess) AS guess_sign,
    ABS(home_score - home_guess) + ABS(away_score - away_guess) AS dist,
    ABS((home_score - away_score) - (home_guess - away_guess)) AS diff_error
)
SELECT
  ROUND(
    (
      25
      - dist * 3
      - diff_error * 2
    )
    *
    CASE
      WHEN actual_sign = guess_sign THEN 1.0     -- full credit
      WHEN actual_sign = 0 OR guess_sign = 0 THEN 0.4  -- partial (draw mismatch)
      ELSE 0.0                                  -- wrong winner
    END
  )::int
FROM vars;
$function$;
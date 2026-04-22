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
    ABS(home_score - home_guess) + ABS(away_score - away_guess) AS dist,
    ABS((home_score - away_score) - (home_guess - away_guess)) AS diff_error
)
SELECT
  CASE
    WHEN home_score = home_guess AND away_score = away_guess THEN 25
    ELSE
      GREATEST(
        0,
        ROUND(
          18 * EXP(-0.35 * dist - 0.25 * diff_error)
        )
      )::int
  END
FROM vars;
$function$;
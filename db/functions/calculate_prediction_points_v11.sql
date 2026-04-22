CREATE OR REPLACE FUNCTION public.calculate_prediction_points(
  home_score  integer,
  away_score  integer,
  home_guess  integer,
  away_guess  integer
)
RETURNS integer
LANGUAGE sql
IMMUTABLE
AS $function$
SELECT
  CASE
    -- 1. EXACT SYNC
    WHEN home_score = home_guess AND away_score = away_guess THEN 25

    -- 2. CORRECT OUTCOME (Win/Draw/Loss)
    WHEN sign(home_score - away_score) = sign(home_guess - away_guess) THEN
      GREATEST(10,
        20
        - (abs(home_score - home_guess) + abs(away_score - away_guess)) * 2
        - abs((home_score - away_score) - (home_guess - away_guess))
      )

    -- 3. SYMMETRICAL PROXIMITY (The Scavenger)
    ELSE
      GREATEST(0, 4 - (abs(home_score - home_guess) + abs(away_score - away_guess)))
  END;
$function$;
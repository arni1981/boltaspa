CREATE OR REPLACE FUNCTION public.calculate_prediction_points(
  home_score integer, away_score integer,
  home_guess integer, away_guess integer
)
RETURNS integer
LANGUAGE sql
IMMUTABLE
AS $function$
  SELECT CASE
    -- 1. THE BULLSEYE: Total Synchronization
    WHEN home_score = home_guess AND away_score = away_guess THEN 25

    -- 2. THE SPIRIT: Correct Outcome with Aggressive Distance Tax
    -- If outcome (Win/Loss/Draw) matches, apply the -4 per goal penalty
    WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess) THEN
      GREATEST(1, 25 - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 4)

    -- 3. THE VOID: Wrong Outcome
    ELSE 0
  END;
$function$
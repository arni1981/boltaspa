CREATE OR REPLACE FUNCTION public.calculate_prediction_points(home_score integer, away_score integer,
                                                              home_guess integer, away_guess integer)
    RETURNS integer
    LANGUAGE sql
    IMMUTABLE
AS
$function$
SELECT CASE
           WHEN home_score = home_guess AND away_score = away_guess THEN 25

           ELSE
               (
                   -- 1. Outcome (dominant signal)
                   CASE
                       WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess)
                           THEN 12
                       ELSE 0
                       END
                       +

                       -- 2. Closeness (primary gradient)
                   GREATEST(
                           0,
                           10 - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2
                   )
                       +

                       -- 3. Goal difference (tiny nudge, not a second scoring system)
                   CASE
                       WHEN (home_score - away_score) = (home_guess - away_guess)
                           THEN 2
                       ELSE 0
                       END
                   )
           END;
$function$
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
      -- Outcome
      CASE
        WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess)
          THEN 10
        ELSE 0
      END

      +

      -- Closeness (with light GD penalty)
      GREATEST(
        0,
        10
        - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2
        - ABS((home_score - away_score) - (home_guess - away_guess)) * 1
      )
    )
END;
$function$
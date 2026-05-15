CREATE OR REPLACE FUNCTION public.upcoming_matches_func(p_competition_ids bigint[], p_window integer DEFAULT 12,
                                                        p_min_matches integer DEFAULT 10)
    RETURNS SETOF matches
    LANGUAGE sql
    STABLE
AS
$function$
      WITH limit_match AS (SELECT kickoff_at::date AS limit_date
                           FROM matches
                           WHERE competition_id = ANY (p_competition_ids)
                             AND kickoff_at > NOW()
                           ORDER BY kickoff_at
                           OFFSET p_min_matches - 1 LIMIT 1),
           cutoff AS (SELECT GREATEST(
                                             CURRENT_DATE + p_window,
                                             COALESCE((SELECT limit_date FROM limit_match), CURRENT_DATE + p_window)
                             ) AS cutoff_date)
      SELECT m.*
      FROM matches m
               CROSS JOIN cutoff
      WHERE m.competition_id = ANY (p_competition_ids)
        AND m.kickoff_at >= (NOW() + INTERVAL '10 minutes')
        AND m.kickoff_at < cutoff_date + INTERVAL '1 day'
      ORDER BY m.kickoff_at;
$function$
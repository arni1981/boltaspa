class UpcomingMatchesView < ActiveRecord::Migration[8.2]
  def change
    execute <<~SQL
                  CREATE OR REPLACE FUNCTION upcoming_matches_func(
                    p_competition_ids BIGINT[],
                    p_window INT DEFAULT 12,
                    p_min_matches INT DEFAULT 10
                  )
                  RETURNS SETOF matches
                  LANGUAGE sql
                  STABLE
                  AS $$
                  WITH limit_match AS (
                    SELECT kickoff_at::date AS limit_date
                    FROM matches
                    WHERE competition_id = ANY(p_competition_ids)
                      AND kickoff_at > NOW()
                    ORDER BY kickoff_at
                    OFFSET p_min_matches - 1
                    LIMIT 1
                  ),
                  cutoff AS (
                    SELECT GREATEST(
                      CURRENT_DATE + p_window,
                      COALESCE((SELECT limit_date FROM limit_match), CURRENT_DATE + p_window)
                    ) AS cutoff_date
                  )
                  SELECT m.*
                  FROM matches m
                  CROSS JOIN cutoff
                  WHERE m.competition_id = ANY(p_competition_ids)
                    AND m.kickoff_at >= NOW()
                    AND m.kickoff_at < cutoff_date + INTERVAL '1 day'
                  ORDER BY m.kickoff_at;
                  $$;

       create function user_incomplete_matches(p_user_id bigint, p_match_ids bigint[]) returns SETOF matches
          language plpgsql
      as
      $$
      DECLARE
          latest_pred_date DATE;
      BEGIN
          -- 1. Find the date of the furthest prediction the user has made within THIS set
          SELECT (m.kickoff_at AT TIME ZONE 'UTC')::DATE INTO latest_pred_date
          FROM predictions p
          JOIN matches m ON p.match_id = m.id
          WHERE p.user_id = p_user_id
            AND p.match_id = ANY(p_match_ids)
          ORDER BY m.kickoff_at DESC
          LIMIT 1;

          -- 2. Return the matches that are part of an "Incomplete" day
          RETURN QUERY
          WITH day_stats AS (
            SELECT
              (m.kickoff_at AT TIME ZONE 'UTC')::DATE as match_date,
              count(m.id) as total_matches,
              count(p.id) as pred_count
            FROM matches m
            LEFT JOIN predictions p ON p.match_id = m.id AND p.user_id = p_user_id
            WHERE m.id = ANY(p_match_ids)
            GROUP BY 1
          )
          SELECT m.*
          FROM matches m
          JOIN day_stats ds ON (m.kickoff_at AT TIME ZONE 'UTC')::DATE = ds.match_date
          LEFT JOIN predictions p ON p.match_id = m.id AND p.user_id = p_user_id
          WHERE m.id = ANY(p_match_ids)
            AND p.id IS NULL -- We only care about the rows that AREN'T predicted yet
            AND (
              (ds.pred_count > 0 AND ds.pred_count < ds.total_matches) -- Partial day
              OR
              (ds.pred_count = 0 AND latest_pred_date IS NOT NULL AND ds.match_date < latest_pred_date) -- Skipped past day
            );
      END;
      $$;

    SQL
  end
end

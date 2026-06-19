WITH matchday_scores AS (
  SELECT lc.id AS league_competition_id,
         p.user_id,
         m.matchday,
         sum(p.points_won) AS matchday_points
    FROM predictions p
    JOIN matches m ON p.match_id = m.id
    JOIN league_competitions lc ON lc.competition_id = m.competition_id
    JOIN memberships ms ON ms.league_id = lc.league_id AND ms.user_id = p.user_id
   WHERE m.status::text = ANY (ARRAY['FINISHED'::text, 'IN_PLAY'::text])
   GROUP BY lc.id, p.user_id, m.matchday
), 
form_agg AS (
  SELECT matchday_scores.league_competition_id,
         matchday_scores.user_id,
         jsonb_object_agg(matchday_scores.matchday, matchday_scores.matchday_points) AS full_form_array
    FROM matchday_scores
   GROUP BY matchday_scores.league_competition_id, matchday_scores.user_id
),
stage_scores AS (
  SELECT lc.id AS league_competition_id,
         p.user_id,
         m.stage,
         sum(p.points_won) AS stage_points
    FROM predictions p
    JOIN matches m ON p.match_id = m.id
    JOIN league_competitions lc ON lc.competition_id = m.competition_id
    JOIN memberships ms ON ms.league_id = lc.league_id AND ms.user_id = p.user_id
   WHERE m.status::text = ANY (ARRAY['FINISHED'::text, 'IN_PLAY'::text])
   GROUP BY lc.id, p.user_id, m.stage
),
stage_form_agg AS (
  SELECT stage_scores.league_competition_id,
         stage_scores.user_id,
         jsonb_object_agg(stage_scores.stage, stage_scores.stage_points) AS full_stage_array
    FROM stage_scores
   GROUP BY stage_scores.league_competition_id, stage_scores.user_id
),
user_performance AS (
  SELECT lc.id AS league_competition_id,
         lc.season_id,
         lc.competition_id,
         ms.league_id,
         p.user_id,
         sum(p.points_won) AS total_points,
         
         /* NEW: Sum points filtered exclusively for matches played today */
         COALESCE(sum(p.points_won) FILTER (WHERE m.kickoff_at::date = CURRENT_DATE), 0) AS today_points,
         
         count(*) FILTER (WHERE (p.points_won = 3)) AS exact_scores,
         count(*) AS predictions_count
    FROM predictions p
    JOIN matches m ON p.match_id = m.id
    JOIN memberships ms ON ms.user_id = p.user_id
    JOIN league_competitions lc ON lc.league_id = ms.league_id AND lc.competition_id = m.competition_id
   WHERE m.status::text = ANY (ARRAY['FINISHED'::text, 'IN_PLAY'::text])
   GROUP BY lc.id, lc.season_id, lc.competition_id, ms.league_id, p.user_id
), 
ranked AS (
  SELECT up.league_competition_id,
         up.season_id,
         up.competition_id,
         up.league_id,
         up.user_id,
         up.total_points,
         up.today_points, /* EXPOSE TO WINDOW LAYER */
         up.exact_scores,
         up.predictions_count,
         COALESCE(fa.full_form_array, '{}'::jsonb) AS full_form_array,
         COALESCE(sfa.full_stage_array, '{}'::jsonb) AS full_stage_array,
         rank() OVER w AS rank,
         lag(up.total_points) OVER w AS prev_points,
         lead(up.total_points) OVER w AS next_points
    FROM user_performance up
    LEFT JOIN form_agg fa ON fa.league_competition_id = up.league_competition_id AND fa.user_id = up.user_id
    LEFT JOIN stage_form_agg sfa ON sfa.league_competition_id = up.league_competition_id AND sfa.user_id = up.user_id
  WINDOW w AS (PARTITION BY up.season_id, up.competition_id, up.league_id ORDER BY up.total_points DESC, up.exact_scores DESC)
)
SELECT ranked.league_competition_id,
       ranked.season_id,
       ranked.competition_id,
       ranked.league_id,
       ranked.user_id,
       ranked.total_points,
       ranked.today_points, /* EXPOSE TO RAILS MODEL */
       ranked.exact_scores,
       ranked.predictions_count,
       ranked.full_form_array,
       ranked.full_stage_array,
       ranked.rank,
       ranked.prev_points,
       ranked.next_points,
       ((ranked.total_points = COALESCE(ranked.prev_points, ('-1'::integer)::bigint)) OR (ranked.total_points = COALESCE(ranked.next_points, ('-1'::integer)::bigint))) AS is_tied
FROM ranked;

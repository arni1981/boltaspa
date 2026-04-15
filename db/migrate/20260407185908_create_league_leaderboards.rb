class CreateLeagueLeaderboards < ActiveRecord::Migration[8.2]
  def change
    execute <<~SQL
      CREATE view standings_view AS
      WITH matchday_scores AS (
        -- Aggregate points per user per matchday across the whole season
        SELECT
          lc.id AS league_competition_id,
          p.user_id,
          m.matchday,
          SUM(p.points_won) AS matchday_points
        FROM predictions p
        JOIN matches m ON p.match_id = m.id
        JOIN league_competitions lc ON lc.competition_id = m.competition_id
        JOIN memberships ms ON ms.league_id = lc.league_id AND ms.user_id = p.user_id
        WHERE m.status in ('FINISHED', 'IN_PLAY')
        GROUP BY lc.id, p.user_id, m.matchday
      ),
      form_agg AS (
        -- Aggregate points into a JSONB array ordered by season progression
        SELECT
          league_competition_id,
          user_id,
          jsonb_agg(matchday_points ORDER BY matchday ASC) AS full_form_array
        FROM matchday_scores
        GROUP BY league_competition_id, user_id
      ),
      user_performance AS (
        -- Standard leaderboard metrics
        SELECT
          lc.id AS league_competition_id,
          lc.season_id,
          lc.competition_id,
          ms.league_id,
          p.user_id,
          SUM(p.points_won) AS total_points,
          COUNT(*) FILTER (WHERE p.points_won = 3) AS exact_scores,
          COUNT(*) AS predictions_count
        FROM predictions p
        JOIN matches m ON p.match_id = m.id
        JOIN memberships ms ON ms.user_id = p.user_id
        JOIN league_competitions lc
          ON lc.league_id = ms.league_id
         AND lc.competition_id = m.competition_id
        WHERE m.status in ('FINISHED', 'IN_PLAY')
        GROUP BY lc.id, lc.season_id, lc.competition_id, ms.league_id, p.user_id
      ),
      ranked AS (
        -- Core ranking logic with tie-breaking and lag/lead for tie detection
        SELECT
          up.league_competition_id,
          up.season_id,
          up.competition_id,
          up.league_id,
          up.user_id,
          up.total_points,
          up.exact_scores,
          up.predictions_count,
          COALESCE(fa.full_form_array, '[]'::jsonb) AS full_form_array,
          RANK() OVER w AS rank,
          LAG(up.total_points) OVER w AS prev_points,
          LEAD(up.total_points) OVER w AS next_points
        FROM user_performance up
        LEFT JOIN form_agg fa
          ON fa.league_competition_id = up.league_competition_id
         AND fa.user_id = up.user_id
        WINDOW w AS (
          PARTITION BY up.season_id, up.competition_id, up.league_id
          ORDER BY up.total_points DESC, up.exact_scores DESC
        )
      )
      SELECT
        league_competition_id,
        season_id,
        competition_id,
        league_id,
        user_id,
        total_points,
        exact_scores,
        predictions_count,
        full_form_array,
        rank,
        prev_points,
        next_points,
        (total_points = COALESCE(prev_points, -1) OR total_points = COALESCE(next_points, -1)) AS is_tied
      FROM ranked;
    SQL
  end
end

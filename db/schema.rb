# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.2].define(version: 2026_04_22_194308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "app_version"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.float "latitude"
    t.float "longitude"
    t.string "os"
    t.string "os_version"
    t.string "platform"
    t.text "referrer"
    t.string "referring_domain"
    t.string "region"
    t.datetime "started_at"
    t.text "user_agent"
    t.bigint "user_id"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "league_competition_id", null: false
    t.integer "matchday", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["league_competition_id", "matchday"], name: "index_comments_on_league_competition_id_and_matchday"
    t.index ["league_competition_id"], name: "index_comments_on_league_competition_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "competition_teams", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.integer "season", null: false
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id", "team_id", "season"], name: "idx_on_competition_id_team_id_season_5929af21b8", unique: true
    t.index ["competition_id"], name: "index_competition_teams_on_competition_id"
    t.index ["team_id"], name: "index_competition_teams_on_team_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "emblem"
    t.integer "external_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_competitions_on_external_id", unique: true
  end

  create_table "league_competition_teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "league_competition_id", null: false
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["league_competition_id", "team_id"], name: "idx_on_league_competition_id_team_id_3d124dbe68", unique: true
    t.index ["league_competition_id"], name: "index_league_competition_teams_on_league_competition_id"
    t.index ["team_id"], name: "index_league_competition_teams_on_team_id"
  end

  create_table "league_competitions", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.bigint "league_id", null: false
    t.bigint "season_id", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_league_competitions_on_competition_id"
    t.index ["league_id", "competition_id", "season_id"], name: "idx_on_league_id_competition_id_season_id_9f762f52fb", unique: true
    t.index ["league_id"], name: "index_league_competitions_on_league_id"
    t.index ["season_id"], name: "index_league_competitions_on_season_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "invite_code"
    t.string "name"
    t.bigint "owner_id", null: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["invite_code"], name: "index_leagues_on_invite_code", unique: true
    t.index ["owner_id", "name"], name: "index_leagues_on_owner_id_and_name", unique: true
    t.index ["owner_id"], name: "index_leagues_on_owner_id"
    t.index ["slug"], name: "index_leagues_on_slug", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.integer "away_score"
    t.bigint "away_team_id", null: false
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.integer "external_id", null: false
    t.string "group"
    t.integer "home_score"
    t.bigint "home_team_id", null: false
    t.datetime "kickoff_at", null: false
    t.integer "matchday"
    t.bigint "season_id", null: false
    t.string "stage"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["away_team_id"], name: "index_matches_on_away_team_id"
    t.index ["competition_id", "season_id", "matchday"], name: "index_matches_on_competition_id_and_season_id_and_matchday"
    t.index ["competition_id"], name: "index_matches_on_competition_id"
    t.index ["external_id"], name: "index_matches_on_external_id", unique: true
    t.index ["home_team_id"], name: "index_matches_on_home_team_id"
    t.index ["matchday"], name: "index_matches_on_matchday"
    t.index ["season_id"], name: "index_matches_on_season_id"
    t.index ["status"], name: "index_matches_on_status"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "league_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["league_id"], name: "index_memberships_on_league_id"
    t.index ["user_id", "league_id"], name: "index_memberships_on_user_id_and_league_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.integer "away_guess", null: false
    t.datetime "created_at", null: false
    t.integer "home_guess", null: false
    t.bigint "match_id", null: false
    t.integer "points_won", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["match_id"], name: "index_predictions_on_match_id"
    t.index ["user_id", "match_id"], name: "index_predictions_on_user_id_and_match_id", unique: true
    t.index ["user_id"], name: "index_predictions_on_user_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.boolean "current"
    t.integer "current_matchday"
    t.datetime "end_date", precision: nil
    t.integer "external_id"
    t.datetime "start_date", precision: nil
    t.datetime "updated_at", null: false
    t.string "winner"
    t.virtual "year", type: :integer, as: "EXTRACT(year FROM start_date)", stored: true
    t.index ["competition_id"], name: "index_seasons_on_competition_id"
    t.index ["external_id"], name: "index_seasons_on_external_id", unique: true
    t.index ["year"], name: "index_seasons_on_year"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crest_url"
    t.integer "external_id", null: false
    t.string "name"
    t.string "short_name"
    t.string "tla"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_teams_on_external_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", limit: 255, default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "path"
    t.string "remote_ip"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "league_competitions"
  add_foreign_key "comments", "users"
  add_foreign_key "competition_teams", "competitions", on_delete: :cascade
  add_foreign_key "competition_teams", "teams", on_delete: :cascade
  add_foreign_key "league_competition_teams", "league_competitions", on_delete: :cascade
  add_foreign_key "league_competition_teams", "teams", on_delete: :cascade
  add_foreign_key "league_competitions", "competitions", on_delete: :cascade
  add_foreign_key "league_competitions", "leagues", on_delete: :cascade
  add_foreign_key "league_competitions", "seasons", on_delete: :cascade
  add_foreign_key "leagues", "users", column: "owner_id", on_delete: :cascade
  add_foreign_key "matches", "competitions", on_delete: :cascade
  add_foreign_key "matches", "teams", column: "away_team_id", on_delete: :cascade
  add_foreign_key "matches", "teams", column: "home_team_id", on_delete: :cascade
  add_foreign_key "memberships", "leagues", on_delete: :cascade
  add_foreign_key "memberships", "users", on_delete: :cascade
  add_foreign_key "predictions", "matches", on_delete: :cascade
  add_foreign_key "predictions", "users", on_delete: :cascade
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade

  create_function :check_match_lockout, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.check_match_lockout()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
            BEGIN
              IF (SELECT kickoff_at FROM matches WHERE id = NEW.match_id) < CURRENT_TIMESTAMP + INTERVAL '10 min' THEN
                RAISE EXCEPTION 'LOCKOUT_ERROR: Match has already started.';
              END IF;
              RETURN NEW;
            END;
            $function$
  SQL

  create_function :user_incomplete_matches, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.user_incomplete_matches(p_user_id bigint, p_match_ids bigint[])
       RETURNS SETOF matches
       LANGUAGE plpgsql
      AS $function$
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
      $function$
  SQL

  create_function :upcoming_matches_func, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.upcoming_matches_func(p_competition_ids bigint[], p_window integer DEFAULT 12, p_min_matches integer DEFAULT 10)
       RETURNS SETOF matches
       LANGUAGE sql
       STABLE
      AS $function$
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
        AND m.kickoff_at >= NOW()
        AND m.kickoff_at < cutoff_date + INTERVAL '1 day'
      ORDER BY m.kickoff_at;
      $function$
  SQL

  create_function :calculate_prediction_points_gpt, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.calculate_prediction_points_gpt(home_score integer, away_score integer, home_guess integer, away_guess integer)
       RETURNS integer
       LANGUAGE sql
       IMMUTABLE
      AS $function$
            SELECT CASE
        WHEN home_score = home_guess AND away_score = away_guess THEN 25

        ELSE
          (
            CASE
              WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess)
                THEN 10
              ELSE 0
            END

            +

            CASE
              WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess)
                THEN GREATEST(0, 10 - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2)
              ELSE GREATEST(0, 6 - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2)
            END
          )
      END;
            $function$
  SQL

  create_function :calculate_prediction_points_gpt2, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.calculate_prediction_points_gpt2(home_score integer, away_score integer, home_guess integer, away_guess integer)
       RETURNS integer
       LANGUAGE sql
       IMMUTABLE
      AS $function$
            SELECT CASE
        WHEN home_score = home_guess AND away_score = away_guess THEN 25

        ELSE
          (CASE
             WHEN SIGN(home_score - away_score) = SIGN(home_guess - away_guess)
               THEN 15
             ELSE 0
           END)
          +
          GREATEST(
            0,
            10 - (ABS(home_score - home_guess) + ABS(away_score - away_guess)) * 2
          )
      END;
            $function$
  SQL

  create_function :calculate_prediction_points, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.calculate_prediction_points(home_score integer, away_score integer, home_guess integer, away_guess integer)
       RETURNS integer
       LANGUAGE sql
       IMMUTABLE
      AS $function$
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
      $function$
  SQL

  create_trigger :trg_prediction_lockout, sql_definition: <<-SQL
      CREATE TRIGGER trg_prediction_lockout BEFORE INSERT OR UPDATE OF home_guess, away_guess ON public.predictions FOR EACH ROW EXECUTE FUNCTION check_match_lockout()
  SQL

  create_view "standings_view", sql_definition: <<-SQL
      WITH matchday_scores AS (
           SELECT lc.id AS league_competition_id,
              p.user_id,
              m.matchday,
              sum(p.points_won) AS matchday_points
             FROM (((predictions p
               JOIN matches m ON ((p.match_id = m.id)))
               JOIN league_competitions lc ON ((lc.competition_id = m.competition_id)))
               JOIN memberships ms ON (((ms.league_id = lc.league_id) AND (ms.user_id = p.user_id))))
            WHERE ((m.status)::text = ANY (ARRAY[('FINISHED'::character varying)::text, ('IN_PLAY'::character varying)::text]))
            GROUP BY lc.id, p.user_id, m.matchday
          ), form_agg AS (
           SELECT matchday_scores.league_competition_id,
              matchday_scores.user_id,
              jsonb_agg(matchday_scores.matchday_points ORDER BY matchday_scores.matchday) AS full_form_array
             FROM matchday_scores
            GROUP BY matchday_scores.league_competition_id, matchday_scores.user_id
          ), user_performance AS (
           SELECT lc.id AS league_competition_id,
              lc.season_id,
              lc.competition_id,
              ms.league_id,
              p.user_id,
              sum(p.points_won) AS total_points,
              count(*) FILTER (WHERE (p.points_won = 3)) AS exact_scores,
              count(*) AS predictions_count
             FROM (((predictions p
               JOIN matches m ON ((p.match_id = m.id)))
               JOIN memberships ms ON ((ms.user_id = p.user_id)))
               JOIN league_competitions lc ON (((lc.league_id = ms.league_id) AND (lc.competition_id = m.competition_id))))
            WHERE ((m.status)::text = ANY (ARRAY[('FINISHED'::character varying)::text, ('IN_PLAY'::character varying)::text]))
            GROUP BY lc.id, lc.season_id, lc.competition_id, ms.league_id, p.user_id
          ), ranked AS (
           SELECT up.league_competition_id,
              up.season_id,
              up.competition_id,
              up.league_id,
              up.user_id,
              up.total_points,
              up.exact_scores,
              up.predictions_count,
              COALESCE(fa.full_form_array, '[]'::jsonb) AS full_form_array,
              rank() OVER w AS rank,
              lag(up.total_points) OVER w AS prev_points,
              lead(up.total_points) OVER w AS next_points
             FROM (user_performance up
               LEFT JOIN form_agg fa ON (((fa.league_competition_id = up.league_competition_id) AND (fa.user_id = up.user_id))))
            WINDOW w AS (PARTITION BY up.season_id, up.competition_id, up.league_id ORDER BY up.total_points DESC, up.exact_scores DESC)
          )
   SELECT ranked.league_competition_id,
      ranked.season_id,
      ranked.competition_id,
      ranked.league_id,
      ranked.user_id,
      ranked.total_points,
      ranked.exact_scores,
      ranked.predictions_count,
      ranked.full_form_array,
      ranked.rank,
      ranked.prev_points,
      ranked.next_points,
      ((ranked.total_points = COALESCE(ranked.prev_points, ('-1'::integer)::bigint)) OR (ranked.total_points = COALESCE(ranked.next_points, ('-1'::integer)::bigint))) AS is_tied
     FROM ranked;
  SQL
end

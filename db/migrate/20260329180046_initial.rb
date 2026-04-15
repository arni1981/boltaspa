class Initial < ActiveRecord::Migration[8.2]
  def up
    create_table 'users', id: :serial, force: :cascade do |t|
      t.string 'email_address', null: false
      t.string 'name'
      t.string 'password_digest', limit: 255, default: '', null: false
      t.index ['email_address'], unique: true

      t.timestamps
    end

    # 1. Competitions (e.g., Premier League, Champions League)
    create_table :competitions do |t|
      t.integer :external_id, null: false
      t.string :name
      t.string :code
      t.string :emblem
      t.timestamps
    end
    add_index :competitions, :external_id, unique: true

    # 2. Teams
    create_table :teams do |t|
      t.integer :external_id, null: false
      t.string :name
      t.string :short_name
      t.string :tla
      t.string :crest_url
      t.timestamps
    end
    add_index :teams, :external_id, unique: true

    # 3. Matches
    create_table :matches do |t|
      t.integer :external_id, null: false
      t.references :competition, null: false, foreign_key: { on_delete: :cascade }
      t.references :home_team, null: false, foreign_key: { to_table: :teams, on_delete: :cascade }
      t.references :away_team, null: false, foreign_key: { to_table: :teams, on_delete: :cascade }
      t.references :season, null: false

      t.datetime :kickoff_at, null: false
      t.string :status
      t.integer :home_score
      t.integer :away_score
      t.integer :matchday
      t.timestamps
    end
    add_index :matches, :external_id, unique: true
    add_index :matches, :status
    add_index :matches, :matchday
    add_index :matches, %i[competition_id season_id matchday]

    # 4. Predictions (The User guesses)
    create_table :predictions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :match, null: false, foreign_key: { on_delete: :cascade }
      t.integer :home_guess, null: false
      t.integer :away_guess, null: false
      t.integer :points_won, default: 0
      t.timestamps
    end
    # Ensure one prediction per user per match
    add_index :predictions, %i[user_id match_id], unique: true

    create_table :seasons do |t|
      t.references :competition, null: false
      t.integer :external_id
      t.boolean :current
      t.timestamp :start_date
      t.timestamp :end_date
      t.integer :current_matchday
      t.string :winner

      t.timestamps
    end

    add_index :seasons, :external_id, unique: true

    # 5. The Postgres Anti-Cheat Trigger
    # This prevents any INSERT or UPDATE if the match has already started.
    execute <<-SQL
      CREATE OR REPLACE FUNCTION check_match_lockout()
      RETURNS TRIGGER AS $$
      BEGIN
        IF (SELECT kickoff_at FROM matches WHERE id = NEW.match_id) < CURRENT_TIMESTAMP + INTERVAL '10 min' THEN
          RAISE EXCEPTION 'LOCKOUT_ERROR: Match has already started.';
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER trg_prediction_lockout
      BEFORE INSERT OR UPDATE OF home_guess, away_guess ON predictions -- Only fires on these columns
      FOR EACH ROW#{' '}
      EXECUTE FUNCTION check_match_lockout();
    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS trg_prediction_lockout ON predictions'
    execute 'DROP FUNCTION IF EXISTS check_match_lockout'
    drop_table :teams
    drop_table :matches
    drop_table :predictions
    drop_table :competitions
    drop_table :users
  end
end

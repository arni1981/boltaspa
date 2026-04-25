class ReminderJob < ApplicationJob
  queue_as :default

  def perform
    find_users.each do |user|
      ReminderMailer.send_reminder(user).deliver_later
    end
  end

  def find_users
    User.find_by_sql <<~SQL
      SELECT DISTINCT
          u.*
      FROM users u
      JOIN memberships lm ON lm.user_id = u.id
      JOIN league_competitions lc ON lc.league_id = lm.league_id
      JOIN matches m ON m.competition_id = lc.competition_id#{' '}
                     AND m.season_id = lc.season_id
      LEFT JOIN predictions p ON p.user_id = u.id#{' '}
                             AND p.match_id = m.id
      WHERE m.kickoff_at::date = CURRENT_DATE
        AND p.id IS NULL
        AND u.send_reminder_email = TRUE;
    SQL
  end
end

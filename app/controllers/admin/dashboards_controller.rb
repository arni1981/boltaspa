module Admin
  class DashboardsController < Admin::BaseController
    def show
      @stats = {
        users_total: User.count,
        leagues_total: League.count,
        predictions_total: Prediction.count,
        active_today: User.where(id: Visit.where(created_at: 24.hours.ago...).select(:user_id)).size
      }

      @latest_users = User.order(created_at: :desc).limit(10)
      @latest_leagues = League.order(created_at: :desc).includes(:owner).limit(10)
      @latest_visits = Visit.where(created_at: 24.hours.ago..).select('max(created_at) as created_at, user_id').group(:user_id)

      # High-engagement users (Most predictions)
      @top_predictors = User.joins(:predictions)
                            .group(:id)
                            .select('users.*, count(predictions.id) as predictions_count')
                            .order('predictions_count DESC')
                            .limit(10)

      @system_stats = {
        queue_backlog: SolidQueue::Job.where(finished_at: nil).count,
        queue_failed: SolidQueue::FailedExecution.count,
        cache_entries: SolidCache::Entry.count,
        # Roughly estimate cache size if using MySQL/Postgres
        cache_size_mb: (SolidCache::Entry.sum('length(key) + length(value)') / 1.megabyte.to_f).round(2)
      }

      # Latest Background Jobs
      @latest_jobs = SolidQueue::Job.order(created_at: :desc).limit(5)

      # Active Connections (Solid Cable)
      # Note: Solid Cable doesn't always have a "count" table,
      # but we can check the messages processed recently.
      @recent_messages = SolidCable::Message.where('created_at > ?', 1.hour.ago).count

      # 1. Latest Cache Keys
      # We pull the last 10 entries. SolidCache stores keys as strings.
      @latest_cache_entries = SolidCache::Entry.order(created_at: :desc).limit(10)

      # 2. Most Frequent Jobs (The "Workhorses")
      # We group by the job_class to see which tasks run most often.
      @job_frequency = SolidQueue::Job.group(:class_name)
                                      .order('count_all DESC')
                                      .count
                                      .first(5)

      # 3. Currently Scheduled/Running Jobs
      @active_jobs = SolidQueue::Job.where(finished_at: nil)
                                    .order(created_at: :desc)
                                    .limit(10)
    end
  end
end

# app/controllers/admin/dashboards_controller.rb
module Admin
  class DashboardsController < Admin::BaseController
    def show
      # Core application KPIs
      @stats = {
        total_users: User.count,
        total_leagues: League.count,
        total_predictions: Prediction.count,
        active_today: User.where(id: Visit.where(created_at: 24.hours.ago...).select(:user_id)).distinct.count
      }

      # Top performance engagement metrics
      @top_predictors = User.joins(:predictions)
                            .group(:id)
                            .select('users.*, count(predictions.id) as predictions_count')
                            .order('predictions_count DESC')
                            .limit(10)

      # 1. FIXED: Latest Unique Visits (Grouped by User)
      # Grabs the last 10 unique users who touched the system, along with their maximum (latest) timestamp
      latest_visit_groups = Visit.where.not(user_id: nil)
                                 .group(:user_id)
                                 .select('user_id, max(created_at) as latest_at')
                                 .order('latest_at DESC')
                                 .limit(10)

      # Map the aggregated results to load the User associations fast
      user_ids = latest_visit_groups.map(&:user_id)
      users_index = User.where(id: user_ids).index_by(&:id)

      @latest_visits = latest_visit_groups.map do |v|
        { user: users_index[v.user_id], updated_at: v.latest_at }
      end.compact

      # 2. FIXED: Mega Leagues (Ordered by Size)
      # Changes focus from timeline noise to actual active volume footprint
      @mega_leagues = League.joins(:members)
                            .group(:id)
                            .select('leagues.*, count(users.id) as users_count')
                            .order('users_count DESC')
                            .limit(10)

      # Fast basic sign-up monitoring array
      @latest_users = User.order(created_at: :desc).limit(10)
    end
  end
end

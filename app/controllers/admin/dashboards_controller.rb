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

      # Growth & Activity monitoring
      @latest_users = User.order(created_at: :desc).limit(10)
      @latest_leagues = League.order(created_at: :desc).limit(10)
      @latest_visits = Visit.includes(:user)
                            .order(created_at: :desc)
                            .limit(10)
    end
  end
end

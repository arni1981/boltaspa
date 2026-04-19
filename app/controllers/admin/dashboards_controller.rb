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

      # High-engagement users (Most predictions)
      @top_predictors = User.joins(:predictions)
                            .group(:id)
                            .select('users.*, count(predictions.id) as predictions_count')
                            .order('predictions_count DESC')
                            .limit(10)
    end
  end
end

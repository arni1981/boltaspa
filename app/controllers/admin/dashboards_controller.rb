# app/controllers/admin/dashboards_controller.rb
module Admin
  class DashboardsController < Admin::BaseController
    def show
      # Core application KPIs
      @stats = {
        total_users: User.count,
        total_leagues: League.count,
        active_today: User.where(id: Visit.where(created_at: 24.hours.ago...).select(:user_id)).distinct.count
      }

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

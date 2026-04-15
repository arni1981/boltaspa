module Admin
  class DashboardController < Admin::BaseController
    def index
      @latest_sign_ups = User
        .order("created_at DESC NULLS LAST")
        .limit(5)

      @latest_visits = Ahoy::Visit
        .where.not(user_id: nil)
        .includes(:user)
        .order(started_at: :desc)
        .limit(10)
    end
  end
end

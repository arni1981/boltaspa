module Admin
  class ProfilesController < Admin::BaseController
    schema(:show) do
      required(:id).filled(:integer)
    end

    def show
      @user = User.find(safe_params[:id])
    end

    def su
      cookies.encrypted[:user_id] = params[:user_id]
      redirect_to dashboard_path
    end
  end
end

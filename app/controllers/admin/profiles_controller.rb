module Admin
  class ProfilesController < Admin::BaseController
    def show
      @user = User.find(safe_params[:id])
    end

    def su
      cookies.encrypted[:user_id] = params[:user_id]
      redirect_to dashboard_path
    end
  end
end

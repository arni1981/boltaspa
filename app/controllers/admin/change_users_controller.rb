module Admin
  # Base
  class ChangeUsersController < BaseController
    def create
      session[:admin_id] = Current.user.id

      user = User.find(params[:user_id])

      start_new_session_for(user)
    end

    def destroy
      user = User.find(session[:admin_id])
      start_new_session_for(user)
    end
  end
end

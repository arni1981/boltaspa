class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit
  end

  def update
    user_params.compact_blank!

    if @user.update(user_params)
      flash[:success] = t('users.update_success')
      redirect_to settings_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(%i[email password password_confirmation name avatar newsletter])
  end

  def set_user
    @user = Current.user
  end
end

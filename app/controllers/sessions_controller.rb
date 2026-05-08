class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create omniauth]

  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
    redirect_to new_session_path, alert: t('controllers.sessions.rate_limit_exceeded')
  }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: t('controllers.sessions.invalid_credentials')
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end

  def omniauth
    auth = request.env['omniauth.auth']

    user = User.find_or_create_by(uid: auth[:uid]) do |u|
      u.email_address = auth[:info][:email]
      u.name = auth[:info][:name]
      u.image_url = auth[:info][:image]

      pass = SecureRandom.hex(15)
      u.password = pass
      u.password_confirmation = pass
    end

    if user.persisted?
      start_new_session_for user
      redirect_to root_path, notice: t('controllers.sessions.signed_in_with_google')
    else
      redirect_to new_session_path, alert: t('controllers.sessions.could_not_sign_in_with_google')
    end
  end
end

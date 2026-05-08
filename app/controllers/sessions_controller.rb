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

    email = auth[:info][:email]

    unless auth[:info][:verified]
      redirect_to new_session_path, alert: 'Google email not verified'
      return
    end

    user = User.find_by(uid: auth[:uid]) || User.find_by(email_address: email)

    if user
      if user.uid.blank? && user.provider.blank?
        user.update!(
          uid: auth[:uid],
          provider: auth[:provider]
        )
      end
    else
      password = SecureRandom.hex(16)

      user = User.create!(
        uid: auth[:uid],
        provider: auth[:provider],
        email_address: email,
        name: auth[:info][:name],
        password: password,
        password_confirmation: password
      )
    end

    start_new_session_for user

    redirect_to root_path, notice: t('controllers.sessions.signed_in_with_google')
  end
end

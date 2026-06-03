class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  include Authentication
  include ErrorModule
  include Trackable

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end

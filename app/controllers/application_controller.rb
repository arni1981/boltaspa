class ApplicationController < ActionController::Base
  stale_when_importmap_changes

  allow_browser versions: :modern

  include Authentication
  include ErrorModule
  include Trackable

  stale_when_importmap_changes

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end

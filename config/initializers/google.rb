Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.app.creds.require('google_id'), Rails.app.creds.require('google_secret')
end

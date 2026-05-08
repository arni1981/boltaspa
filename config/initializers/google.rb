Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.app.creds('google_id'), Rails.app.creds('google_secret')
end

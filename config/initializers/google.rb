Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.require('google_id'),
           Rails.application.credentials.require('google_secret')
end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Specify your exact CDN subdomain here
    origins 'https://cdn.betraskor.is'

    resource '*',
             headers: :any,
             methods: %i[get options head], # CDNs typically only need read access
             max_age: 86_400 # Reduces preflight OPTIONS requests by caching the response (24 hours)
  end
end

Rails.application.configure do
  # ... your other configuration settings ...

  # Ensure static files are handled with proper headers
  config.public_file_server.enabled = true

  config.public_file_server.headers = {
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => 'GET, OPTIONS',
    'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept',
    'Cache-Control' => 'public, max-age=31536000'
  }
end

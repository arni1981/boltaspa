source 'https://gem.coop'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# --- Core Framework & Servers ---
gem 'bootsnap', require: false
gem 'rails'

# --- Database & Advanced SQL Engine ---
gem 'fx'
gem 'pg'
gem 'scenic'

# --- The "Solid" Infrastructure Stack ---
gem 'mission_control-jobs' # Dashboard for Solid Queue
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# --- Authentication & Identity ---
gem 'bcrypt'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# --- Frontend Asset Pipeline & UI Frameworks ---
gem 'importmap-rails'
gem 'propshaft'
gem 'stimulus-rails'
gem 'tailwindcss-rails', '~> 4.4'
gem 'turbo-rails'

# --- Services & Utilities ---
gem 'faraday'
gem 'image_processing', '~> 1.2'

# --- Production Observability ---
gem 'rollbar'

# --- Development & Test Components ---
group :development, :test do
  gem 'debug'
  gem 'faker'
  gem 'overmind'
  gem 'rubocop-rails-omakase'
  gem 'solargraph'
end

# --- Development Environment Optimization ---
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'puma'
  gem 'web-console'
end

# --- Integration Testing ---
group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

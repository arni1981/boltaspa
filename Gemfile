source 'https://gem.coop'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# --- Core Rails & Database ---
gem 'bootsnap', require: false
gem 'pg'
gem 'propshaft'
gem 'rails', github: 'rails/rails'

# --- The "Solid" Infrastructure (Queue/Cache/Cable) ---
gem 'mission_control-jobs' # Dashboard for Solid Queue
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

# --- Authentication & Social ---
gem 'bcrypt'

gem 'faraday'

# --- Frontend & UI ---
gem 'importmap-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails', '~> 4.4'
gem 'turbo-rails'

# --- Monitoring & Analytics ---
gem 'rollbar'

# --- Development & Test Groups ---
group :development, :test do
  gem 'debug'      # Debugger
  gem 'faker'
  gem 'overmind'   # Procfile manager
  gem 'solargraph' # Language Server
  gem 'standard'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'puma'       # Strictly for local development
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

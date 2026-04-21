Rails.application.routes.draw do
  # 1. THE EXTERNAL GATEKEEPER
  # Redirects boltaspá.com to boltaspá.com/is (or /en)
  # We use 'get' here, not 'root', to avoid name collisions.
  get '/', to: redirect("/#{I18n.default_locale}"), constraints: ->(req) { req.path == '/' }

  # 2. SYSTEM & MACHINE ROUTES (No Locale)
  mount MissionControl::Jobs::Engine, at: '/jobs'
  get 'auth/:provider/callback', to: 'sessions#omniauth'

  match '/404', to: 'errors#error404', via: :all
  match '/500', to: 'errors#error500', via: :all

  # 3. THE LOCALIZED UI ENGINE
  scope '/:locale', locale: /#{I18n.available_locales.join('|')}/ do
    # AUTHENTICATED ENTRY
    # We use 'get' and a custom name to avoid the "Too many roots" error.
    # This maps to e.g., boltaspá.com/is/
    get '/', to: 'dashboard#show',
             constraints: AuthConstraint,
             as: :authenticated_root

    # PUBLIC ENTRY (The official 'root')
    # This also maps to e.g., boltaspá.com/is/ but only if AuthConstraint fails.
    root to: 'welcome#show'

    # --- THE CORE APP ---
    resource :dashboard, only: :show
    get 'scoring' => 'pages#scoring'

    resources :predictions, only: %i[index create]
    resource :onboarding, only: :show

    # AUTHENTICATION
    get  'sign_up', to: 'registrations#new'
    post 'sign_up', to: 'registrations#create'
    resource :session, only: %i[new create destroy]
    resources :passwords, only: %i[new create edit update], param: :token

    # LEAGUES
    resources :leagues, param: :slug, path: 'l' do
      resources :league_competitions, only: [] do
        resources :comments, only: [:create]
      end

      get 'competitions/:competition_code/:year',
          to: 'league_competitions#show',
          as: :competition_by_year
    end

    # SETTINGS & MEMBERSHIPS
    resource :settings, only: %i[edit update], controller: 'users'
    resources :memberships, only: %i[create destroy]
    get 'join_league/(:invite_code)', to: 'memberships#new', as: :join_league
    post 'join_league/(:invite_code)', to: 'memberships#create'

    namespace :admin do
      resource :dashboard, only: :show
    end
  end
end

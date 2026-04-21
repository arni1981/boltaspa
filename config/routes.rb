Rails.application.routes.draw do
  resources :predictions, only: %i[index create]
  resource :onboarding, only: :show

  # --- AUTHENTICATION & ACCOUNT ---
  get  'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'

  resource  :session,   only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update], param: :token

  # Vanity URL for social sharing
  get 'join_league/(:invite_code)', to: 'memberships#new', as: :join_league
  post 'join_league/(:invite_code)', to: 'memberships#create'

  # --- SETTINGS ---
  # Using a singular resource for settings makes the helper 'edit_settings_path'
  resource :settings, only: %i[edit update], controller: 'users'

  # --- THE CORE APP ---
  resources :leagues, param: :slug, path: 'l' do
    resources :league_competitions, only: [] do
      resources :comments, only: [:create]
    end

    # Nested route for league competitions
    get 'competitions/:competition_code/:year',
        to: 'league_competitions#show',
        as: :competition_by_year
  end

  get 'scoring' => 'pages#scoring'
  resources :memberships, only: %i[create destroy]
  resource :dashboard, only: :show

  # OmniAuth
  get 'auth/:provider/callback', to: 'sessions#omniauth'

  # --- ADMIN & OPS ---
  namespace :admin do
    resource :dashboard, only: :show
  end

  mount MissionControl::Jobs::Engine, at: '/jobs'

  # --- SYSTEM & ERRORS ---
  get 'invalid_record', to: 'errors#invalid_record'
  match '/404', to: 'errors#error404', via: :all
  match '/500', to: 'errors#error500', via: :all

  # --- ROOT LOGIC ---
  constraints AuthConstraint do
    root to: 'dashboard#show', as: :authenticated_root
  end

  root to: 'welcome#show'
end

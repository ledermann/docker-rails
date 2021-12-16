require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      mount Shrine.presign_endpoint(:cache) => '/presign'

      post 'user_token' => 'user_token#create'

      resources :posts do
        collection do
          get :autocomplete
        end

        resources :audits, only: [ :index ]
      end

      resource :about, only: [ :show ], controller: 'about'
    end
  end

  constraints Clearance::Constraints::SignedIn.new(&:is_admin?) do
    mount Sidekiq::Web => '/sidekiq'
    mount Blazer::Engine, at: 'blazer'
  end

  # Authentication with Clearance
  resource :session, controller: 'clearance/sessions', only: [:create]
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resources :users, only: [:create] do
    resource :password, controller: 'clearance/passwords', only: [:create, :edit, :update]
  end

  get    '/confirm/:user_id/:token'  => 'users#confirm',              as: 'confirm'
  get    '/sign_in'                  => 'clearance/sessions#new',     as: 'sign_in'
  delete '/sign_out'                 => 'clearance/sessions#destroy', as: 'sign_out'
  get    '/sign_up'                  => 'users#new',                  as: 'sign_up'

  resources :posts do
    resources :audits, only: [ :index ]
  end

  root to: 'posts#index'

  # Catch all to avoid FATAL error logging
  match '*path', via: :all, to: 'errors#not_found'
end

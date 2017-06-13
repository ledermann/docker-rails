require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

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
    collection do
      get :autocomplete, constraints: lambda { |req| req.format == :json }
    end
  end

  root to: 'posts#index'

  # Catch all to avoid FATAL error logging
  match '*path', via: :all, to: 'errors#error_404'
end

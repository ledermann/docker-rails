require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts

  root to: "posts#index"

  mount Sidekiq::Web => '/sidekiq'
end

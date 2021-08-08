require 'sidekiq/web'

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
 
  resources :products

  resources :clients do 
    resources :lists,  only: [:index, :create, :update, :destroy]
  end
  
  post "/sign_in", to: "clients#sign_in"
  get "/auth_token", to: "clients#auth_token"

  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  # For details, on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
 
  resources :products
  post "/many/products", to: "products#many"

  resources :clients do 
    resources :lists,  only: [:index, :create, :update, :destroy]
  end
  
  post "/sign_in", to: "clients#sign_in"
  get "/auth_token", to: "clients#auth_token"

  # For details, on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

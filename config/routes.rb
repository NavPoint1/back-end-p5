Rails.application.routes.draw do
  resources :slides
  resources :guides, except: [:new, :edit]
  resources :users, only: [:create, :update, :destroy]
  
  post "/login", to: "users#login", as: "login"
  get "/logout", to: "users#logout", as: "logout"
end

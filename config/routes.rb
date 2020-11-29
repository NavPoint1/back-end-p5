Rails.application.routes.draw do
  post "/users/:id/like", to: "users#like", as: "like_toggle"
  
  # resources :likes
  # resources :slides
  resources :guides, except: [:new, :edit]
  resources :users, only: [:create, :update, :destroy]
  
  post "/login", to: "users#login", as: "login"
  get "/logout", to: "users#logout", as: "logout"
end

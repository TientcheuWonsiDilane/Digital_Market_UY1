Rails.application.routes.draw do
  resources :stores do
    member do
      post :connect
    end
  end

  resources :items
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  devise_for :users

  get "dashboard", to: "dashboard#index"
  get "produits", to: redirect("/items")
  get "boutiques", to: redirect("/stores")
  resources :products, only: [:show]

  # Auth-aware root - logged in users go to items feed
  authenticated :user do
    root to: "items#index", as: :authenticated_user_root
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Public root (non-authenticated)
  root "pages#home"
end

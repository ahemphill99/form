Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users

  # Root route
  authenticated :user do
    root "forms#index", as: :authenticated_root
  end
  root "home#index"

  # Response routes
  get "responses", to: "dashboard#all_responses"

  # Form routes
  resources :forms do
    # Question routes
    resources :questions do
      # Move question route
      member do
        patch "move"
      end
    end

    # Form responses route
    member do
      get "responses"
    end
  end

  # Public namespace
  namespace :public do
    # Public form routes
    resources :forms, param: :public_token, only: [ :show, :create ] do
      # Submit form route
      member do
        post "submit"
        get "review"
      end

      # Public question routes
      resources :questions, only: [ :show ] do
        # Answer question route
        member do
          post "answer"
        end
      end
    end
    root "forms#index"
  end

  # Subscription routes
  resources :subscriptions, only: [ :index, :new, :create ] do
    collection do
      get "success"
      get "error"
    end
  end

  # Pricing route
  get "pricing", to: "subscriptions#pricing"
end

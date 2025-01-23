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

  # Public form routes
  scope module: 'public' do
    resources :forms, only: [:show], path: 'public/forms', param: :public_token do
      member do
        post :submit
        get :thank_you
      end
    end
  end

  # Subscription routes
  resources :subscriptions, only: [ :index, :new, :create ] do
    collection do
      get :success
      get :cancel
    end
  end

  get "pricing", to: "subscriptions#pricing"
end

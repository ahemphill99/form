Rails.application.routes.draw do
  devise_for :users
  
  root "forms#index"
  get 'dashboard', to: 'dashboard#index'
  get 'responses', to: 'dashboard#all_responses'
  
  resources :forms do
    resources :questions do
      member do
        patch :move
      end
    end
    member do
      get :responses
    end
  end

  namespace :public do
    resources :forms, param: :public_token, only: [:show] do
      member do
        post :submit
        get :review
      end
      
      resources :questions, only: [:show] do
        member do
          post :answer
        end
      end
    end
  end
end

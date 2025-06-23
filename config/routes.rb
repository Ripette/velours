Rails.application.routes.draw do
  devise_for :users

  root 'favor_requests#index'

  resources :favor_requests do
    collection do
      get 'setup_partner', to: 'favor_requests#setup_partner_form'
      post 'setup_partner', to: 'favor_requests#create_partner'
      delete 'disconnect_partner'
    end
    member do
      patch 'accept'
      patch 'decline'
    end
  end

  resources :conversations, only: [:index, :show, :destroy] do
    resources :messages, only: [:create]
  end

  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "posts#index"
end

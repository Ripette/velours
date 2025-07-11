Rails.application.routes.draw do
  devise_for :users

  # Routes pour les favor requests
  resources :favor_requests do
    member do
      post :setup_partner
      post :send_convocation
    end
  end

  # Routes pour les conversations et messages
  resources :conversations, only: [:index, :show] do
    resources :messages, only: [:create]
  end

  # Route pour tester les notifications
  post '/test_notification', to: 'application#test_notification'

  root 'favor_requests#index'
end

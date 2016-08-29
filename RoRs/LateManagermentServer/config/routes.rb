Rails.application.routes.draw do

  devise_for :users , :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  root to: 'homes#index'

  resources :users
  resources :messages

  # API routing
  namespace :api, defaults: { format: :json } do
    scope :v1 do
      resources :users
      resources :messages
    end
  end

  get '*path', to: 'api/base#error_404'
end

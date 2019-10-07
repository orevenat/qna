require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :voted do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  concern :commented do
    resources :comments, only: :create, shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], only: %i[create update destroy], shallow: true do
      post :set_best, on: :member
    end
  end

  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:show, :create, :update, :destroy]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end

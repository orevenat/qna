Rails.application.routes.draw do
  devise_for :users

  concern :voted do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, only: [:create, :update, :destroy], shallow: true do
      post :set_best, on: :member
    end
  end

  resources :rewards, only: :index

  root to: 'questions#index'
end

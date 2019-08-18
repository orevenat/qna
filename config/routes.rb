Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      post :set_best, on: :member
    end
  end

  resources :rewards, only: :index

  root to: 'questions#index'
end

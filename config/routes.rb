Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:create, :update, :destroy], shallow: true
  end

  root to: 'questions#index'
end

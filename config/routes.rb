Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:create, :destroy], shallow: true
  end

  root to: 'questions#index'
end

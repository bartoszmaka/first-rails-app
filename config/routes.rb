Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :articles do
    resources :comments
  end

  resources :votables, only: [] do
    resource :votes, only: [:create, :destroy, :update]
  end

  resources :users

  resources :tags
  get     '/login',         to: 'sessions#new'
  post    '/login',         to: 'sessions#create'
  delete  '/logout',        to: 'sessions#destroy', as: 'logout'
  get     '/denied',        to: 'static#denied'
end

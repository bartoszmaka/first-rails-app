Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'welcome#index'
  resources :articles do
    resources :comments
  end

  resources :votables, only: [] do
    resource :votes, only: [:create, :destroy, :update]
  end

  resources :users, only: [:show, :index]

  resources :tags
  # get     '/login',         to: 'sessions#new'
  # post    '/login',         to: 'sessions#create'
  # delete  '/logout',        to: 'sessions#destroy', as: 'logout'
  get '/denied', to: 'static#denied'
end

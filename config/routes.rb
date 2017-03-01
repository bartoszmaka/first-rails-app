Rails.application.routes.draw do
  root 'welcome#index'
  resources :articles do
    resources :comments
  end

  resources :votables, only: [] do
    resource :votes, only: [:create, :destroy, :update]
  end

  resources :users, only: [:show, :new, :create]

  resources :tags
  get     '/login',         to: 'sessions#new'
  post    '/login',         to: 'sessions#create'
  delete  '/logout',        to: 'sessions#destroy', as: 'logout'
  # get     '/users/:id',     to: 'users#show',           as: 'user'
  # get     '/signup',        to: 'users#new',            as: 'signup'
  # post    '/users',         to: 'users#create',         as: 'register'
  get     '/denied',        to: 'static#denied'
end

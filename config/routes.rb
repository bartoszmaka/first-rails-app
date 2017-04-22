Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root 'welcome#index'

  resources :articles do
    resources :comments
  end

  resources :votables, only: [] do
    resource :votes, only: %i[create destroy update]
  end

  resources :users, only: %i[show index]

  resources :tags

  get '/denied', to: 'static#denied'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end

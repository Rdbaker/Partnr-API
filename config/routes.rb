Rails.application.routes.draw do
  devise_for :user do
    post '/login', to: 'devise/sessions#create'
    post '/signup', to: 'devise/registrations#create'
  end

  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  # A conversation is a group of message between two or more users
  resources :conversation, only: [:show]
  # A message sent from one user to one or more users
  resources :messages, only: [:create]

  root 'welcome#index'
end

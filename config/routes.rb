Rails.application.routes.draw do
  devise_for :user do
    post '/login', to: 'devise/sessions#create'
    post '/signup', to: 'devise/registrations#create'
  end

  # send a message
  get '/messages', to: 'messages#index', as: 'messages'
  get '/messages/:id', to: 'messages#show', as: 'show_messages'
  post '/messages', to: 'messages#create'
  put '/messages/:id', to: 'messages#new', as: 'new_messages'

  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  root 'welcome#index'
end

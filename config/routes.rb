Rails.application.routes.draw do
  devise_for :user do
    post '/login', to: 'devise/sessions#create'
    post '/signup', to: 'devise/registrations#create'
  end

  # send a message
  get '/messages', to: 'messages#index'
  get '/messages/:id', to: 'messages#show', as: 'show_message'
  post '/messages', to: 'messages#create'
  put '/messages/:id', to: 'messages#new'

  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  root 'welcome#index'
end

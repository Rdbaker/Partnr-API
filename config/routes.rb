Rails.application.routes.draw do
  devise_for :user do
    post '/login', to: 'devise/sessions#create'
    post '/signup', to: 'devise/registrations#create'
  end

  namespace :api do
    resources :projects, except: [:new, :edit]

    get '/messages', to: 'messages#index', as: 'messages'
    post '/messages', to: 'messages#create'
    get '/messages/:id', to: 'messages#show', as: 'message'
    put '/messages/:id', to: 'messages#new'
  end

  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  root 'welcome#index'
end

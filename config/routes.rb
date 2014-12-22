Rails.application.routes.draw do
  devise_for :user do
    post '/login', to: 'devise/sessions#create'
    post '/signup', to: 'devise/registrations#create'
  end

  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  root 'welcome#index'
end

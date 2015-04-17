Rails.application.routes.draw do
  scope '/api' do
    devise_for :users, :controllers => {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  end

  mount Base => '/api'
  mount GrapeSwaggerRails::Engine => '/docs'


  authenticated :user do
    root to: 'loggedin#index', as: 'home'
  end

  root 'welcome#index'
end

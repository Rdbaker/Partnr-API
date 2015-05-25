Rails.application.routes.draw do
  scope '/api' do
    devise_for :users, :controllers => {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  end

  mount Base => '/api'
  mount GrapeSwaggerRails::Engine => '/docs'

  root to: 'application#angular'
end

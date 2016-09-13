Rails.application.routes.draw do
  get '/status', to: 'status#check'

  scope '/api' do
    devise_for :users, :controllers => {
      sessions: 'sessions',
      registrations: 'registrations',
      confirmations: 'confirmations'
    }
  end

  mount Base => '/api'

  root to: 'application#angular'
end

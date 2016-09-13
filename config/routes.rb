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
  mount GrapeSwaggerRails::Engine => '/docs'

  root to: 'application#angular'

  if Rails.env.production?
    get '*path', to: redirect(:host => "http://app.partnr-up.com", :port => 80)
  else
    get '*path', to: redirect(:host => "http://dev.partnr-up.com", :port => 80)
  end

end

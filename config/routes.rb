require 'sidekiq/web'

Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: %i[create destroy]

  resources :backups
  if ENV['ADMIN_PASSWORD']
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'admin' && password == ENV['ADMIN_PASSWORD']
    end
  end
  mount Sidekiq::Web => '/sidekiq'

  resources :projects

  root 'projects#index'
end

require 'sidekiq/web'

Rails.application.routes.draw do
  if ENV['ADMIN_PASSWORD']
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'admin' && password == ENV['ADMIN_PASSWORD']
    end
  end
  mount Sidekiq::Web => '/sidekiq'

  resources :projects
  
  root 'projects#index'
end

require "sidekiq/web"
require "rack/session"

Sidekiq::Web.use Rack::Session::Cookie,
  secret: Rails.application.secret_key_base,
  same_site: true,
  max_age: 86_400 # 1 day in seconds

Rails.application.routes.draw do
  # mount sidekiq dashboard only in development
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  devise_for :users,
             # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

             # Defines the root path route ("/")
             # root "articles#index"
             defaults: { format: :json },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }
  resources :projects do
    resources :uploads, only: %i[index show create]
  end
end

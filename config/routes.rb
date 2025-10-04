Rails.application.routes.draw do
  get "uploads/index"
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

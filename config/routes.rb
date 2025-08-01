Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post 'sign_in', to: 'auth#sign_in'
      post 'sign_up', to: 'auth#sign_up'
      post "password/forgot", to: "auth#forgot_password"
      post "password/reset", to: "auth#reset_password"
      get 'me', to: 'users#me'
      resource :user_settings, only: [:update]
      resources :fixture_lists do
        post "query", on: :collection
        get 'meta', on: :collection
      end
    end
  end
end

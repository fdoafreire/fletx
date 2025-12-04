Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do

      devise_for :users, skip: [:registrations, :passwords, :confirmations], controllers: {
        sessions: 'api/v1/sessions'
      }      

      resources :manifestos, only: [:create, :show] do
        member do
          # PATCH /api/v1/manifestos/:id/start
          patch :start 
        end
      end
      
      resources :stops, only: [] do 
        member do
          # PATCH /api/v1/stops/:id/complete
          patch :complete 
        end
      end
      
    end
  end
end

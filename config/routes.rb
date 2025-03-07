Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/docs"
  mount Rswag::Api::Engine => "/docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # Defines the root path route ("/")
  # root "posts#index"

  resources :queues, only: [ :index ]

  api_version module: "V1", path: { value: "v1" } do
    resources :users, only: [ :index ] do
      collection do
        patch "batch_inactivate"
      end
    end
  end
end

Rails.application.routes.draw do
  root 'api/v1/tokens#verify'
  namespace :api do
    namespace :v1 do
      resource :users, only: [:create, :update, :destroy] do
        collection do
          get ':token/activate', to: 'activation#activate'
          patch ':token/activate', to: 'activation#perform_activation'
          post 'login'
        end
        member do
          delete 'logout'
        end
        resources :tokens, only: [:index]
      end
      get 'verify', to: 'tokens#verify'
    end
  end

  apipie
end

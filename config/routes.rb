Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update, :destroy] do
        collection do
          get ':token/activate', to: 'users#activate'
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

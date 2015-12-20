Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update, :destroy] do
        collection do
          get ':token/activate', to: 'users#activate'
        end
      end
    end
  end
  apipie
end

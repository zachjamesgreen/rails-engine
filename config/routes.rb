Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/search', to: 'merchants/search#index'
      get 'items/search', to: 'items/search#index'
      resources :customers, only: [:index]
      resources :items, except: [:new, :edit] do
        resources :merchants, module: 'items', only: [:index]
      end
      resources :merchants, only: [:index] do
        resources :items, module: 'merchants', only: [:index]
      end
    end
  end
end

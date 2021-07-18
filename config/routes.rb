Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'items/find_all', to: 'items/search#find_all'
      resources :customers, only: [:index]
      resources :items, except: [:new, :edit] do
        resources :merchant, module: 'items', only: [:index]
      end
      resources :merchants, only: [:index, :show] do
        resources :items, module: 'merchants', only: [:index]
      end
    end
  end
end

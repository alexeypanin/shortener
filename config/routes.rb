Rails.application.routes.draw do
  resources :urls, only: [:create, :show] do
    member do
      get :stats
    end
  end
end

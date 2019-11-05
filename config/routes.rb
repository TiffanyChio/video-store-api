Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]
  resources :rentals, only: [:create]
end

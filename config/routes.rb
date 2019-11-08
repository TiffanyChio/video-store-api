Rails.application.routes.draw do
  resources :customers, only: [:index]
  resources :movies, only: [:index, :show, :create]
  post "/rentals/check-out", to: "rentals#check_out", as: "check_out"
  post "/rentals/check-in", to: "rentals#check_in", as: "check_in"
  get "/rentals/overdue", to: "rentals#overdue", as: "overdue"
  get "/movies/:id/current", to: "movies#current", as: "current_movie"
  get "/movies/:id/history", to: "movies#history", as: "movie_history"
end

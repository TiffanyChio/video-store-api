class MoviesController < ApplicationController
  def index
    movies = Movie.all.as_json(only: [:id, :title, :overview, :release_date, :inventory, :available_inventory])
    render json: movies, status: :ok
    
  end
  
  def show
    movie = Movie.find_by(id: params[:id]).as_json(only: [:title, :overview, :release_date, :inventory, :available_inventory])
    if movie
      render json: movie, status: :ok
    else
      render json: {errors: "could not find movie with id #{params[:id]}"}, status: :not_found
    end
  end
  
  def create
  end
end

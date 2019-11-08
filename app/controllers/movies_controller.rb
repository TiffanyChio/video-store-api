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
    movie = Movie.new(movie_params)
    movie.available_inventory = movie.inventory
    
    if movie.save
      render json: movie.as_json(only: [:id]), status: :ok
      return
    else
      render json: {
        ok: false,
        errors: movie.errors.messages
      }, 
      status: :bad_request
      return
    end
  end
  
  def current
    movie = Movie.find_by(id: params[:id])
    
    if movie.nil?
      render json: {
        ok: false,
        errors: "No movie assossiated with ID #{params[:id]}."
      }, 
      status: :not_found
      return
    end
    
    current_rentals = movie.find_rentals("current").as_json
    
    render json: current_rentals, status: :ok
    return
  end
  
  def history
    movie = Movie.find_by(id: params[:id])
    
    if movie.nil?
      render json: {
        ok: false,
        errors: "No movie assossiated with ID #{params[:id]}."
      }, 
      status: :not_found
      return
    end
    
    past_rentals = movie.find_rentals("past").as_json
    
    render json: past_rentals, status: :ok
    return
  end
  
  private
  
  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end
end

class RentalsController < ApplicationController
  
  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    movie = Movie.find_by(id: params[:movie_id])
    
    if movie
      movie = movie.in_stock
    end
    
    if movie && customer
      rental = Rental.new(customer_id: customer.id, movie_id: movie.id)
      rental.check_out_date = Date.today
      rental.due_date = Date.today + 7
      if rental.save
        movie.decrease_inventory
        customer.add_to_checked_out
        render json: rental.as_json(only: [:id, :due_date]), status: :ok
        return
      else
        render json: {
          ok: false,
          errors: rental.errors.messages
        }, 
        status: :bad_request
        return
      end
    else
      render json: {
        ok: false,
        errors: "Unable to create rental"
      },
      status: :bad_request
      return
    end
  end
  
  def check_in
    customer = Customer.find_by(id: params[:customer_id])
    movie = Movie.find_by(id: params[:movie_id])
    
    if movie && customer
      rental = Rental.find_by(customer_id: customer.id, movie_id: movie.id, check_in_date: nil)
      
      if rental
        rental.check_in_date = Date.today
        
        if rental.save
          movie.increase_inventory
          customer.remove_checked_out
          render json: rental.as_json(only: [:id]), status: :ok
          return
        else
          render json: {
            ok: false,
            errors: rental.errors.messages
          }, 
          status: :bad_request
          return
        end
      else
        render json: {
          ok: false,
          errors: "Unable to check-in rental. Could not find rental record."
        },
        status: :bad_request
        return
      end
      
    else
      render json: {
        ok: false,
        errors: "Unable to check-in rental. Please check inputs."
      },
      status: :bad_request
      return
    end
  end

  def overdue
    overdue_rentals = Rental.where(check_in_date: nil).where("due_date < ?", Date.today).as_json(only: [:id, :check_in_date, :check_out_date, :due_date, :movie_id, :customer_id])
    if overdue_rentals.empty?
      render json: { errors: "No overdue movies at this time" }, status: :ok
      return
    else
      render json: overdue_rentals, status: :ok
    end
  end
  
end

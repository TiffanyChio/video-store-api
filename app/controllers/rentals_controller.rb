class RentalsController < ApplicationController

  def check_out
    customer = Customer.find_by(id: params[:customer_id])
    movie = Movie.find_by(id: params[:movie_id])

    if movie && customer
      rental = Rental.new(customer_id: customer.id, movie_id: movie.id)
      rental.check_out_date = Date.today
      rental.due_date = Date.today + 7
      if rental.save
        movie.decrease_inventory
        customer.add_to_checked_out
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
        errors: "Unable to create rental"
      },
      status: :bad_request
      return
    end
  end

  def check_in

  end

end

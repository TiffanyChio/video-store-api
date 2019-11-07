require "test_helper"

describe RentalsController do
  let(:rental_params){
    {"customer_id" => customers(:bob).id.to_s,
      "movie_id" => movies(:one).id.to_s,
    }
  }
  describe "check_out" do
    it "creates a new rental" do
      expect{ post check_out_path, params: rental_params}.must_change "Rental.count", 1
      
      check_response(expected_type: Hash, expected_status: :ok)
      
    end
    
    it "returns a bad request if movie or customer is missing" do
      rental_params["movie_id"] = nil
      expect{ post check_out_path, params: rental_params}.wont_change "Rental.count"
      check_response(expected_type: Hash, expected_status: :bad_request)
    end
    
    it "increases a customer's checked out and decreases movie's inventory" do
      before_movie_count = movies(:one).available_inventory
      before_cust_count = customers(:bob).movies_checked_out_count
      post check_out_path, params: rental_params
      updated_movie = Movie.find_by(id: movies(:one).id)
      updated_cust = Customer.find_by(id: customers(:bob).id)
      expect(updated_movie.available_inventory).must_equal before_movie_count - 1
      expect(updated_cust.movies_checked_out_count).must_equal before_cust_count + 1
    end
    
    it "returns bad request if the movie is not in stock" do
      movie = movies(:one)
      movie.available_inventory = 0
      movie.save!
      
      expect{ post check_out_path, params: rental_params}.wont_change "Rental.count"
      check_response(expected_type: Hash, expected_status: :bad_request)
    end
  end
  
  describe "check_in" do
    it "can update a rental with valid data" do
      post check_out_path, params: rental_params
      expect{ post check_in_path, params: rental_params }.wont_change "Rental.count"
      check_response(expected_type: Hash)
    end
    
    it "bad request if there is no checked out rental with given movie and customer id" do
      expect{ post check_in_path, params: rental_params }.wont_change "Rental.count"
      check_response(expected_type: Hash, expected_status: :bad_request)
    end
    
    it "returns bad_request if movie or customer id is missing" do
      rental_params["movie_id"] = nil
      expect{ post check_in_path, params: rental_params}.wont_change "Rental.count"
      check_response(expected_type: Hash, expected_status: :bad_request)
    end
    
    it "decreases a customer's checked out and increases movie's inventory" do
      post check_out_path, params: rental_params
      
      before_movie_count = Movie.find_by(id: movies(:one).id).available_inventory
      before_cust_count = Customer.find_by(id: customers(:bob).id).movies_checked_out_count
      
      post check_in_path, params: rental_params
      
      updated_movie = Movie.find_by(id: movies(:one).id)
      updated_cust = Customer.find_by(id: customers(:bob).id)
      
      expect(updated_movie.available_inventory).must_equal before_movie_count + 1
      expect(updated_cust.movies_checked_out_count).must_equal before_cust_count - 1
    end
    
    it "finds the correct rental if more than one exists for the same movie/customer combination" do
      post check_out_path, params: rental_params
      post check_in_path, params: rental_params
      
      post check_out_path, params: rental_params
      current_rental = Rental.last
      expect(current_rental.check_in_date).must_be_nil
      
      post check_in_path, params: rental_params
      
      updated_rental = Rental.find_by(id: current_rental.id)
      expect(updated_rental.check_in_date).must_equal Date.today
    end
    
    it "returns bad request when checking in an already check-ed in movie" do
      post check_out_path, params: rental_params
      post check_in_path, params: rental_params
      
      post check_in_path, params: rental_params
      check_response(expected_type: Hash, expected_status: :bad_request)
    end
  end

  describe "overdue" do
    it "returns all rentals that have due dates that have passed" do
      get overdue_path

      check_response(expected_type: Array)
      
      body = JSON.parse(response.body)
      
      body.each do |rental|
        expect(rental).must_be_instance_of Hash
        expect(rental.keys.sort).must_equal ["check_in_date", "check_out_date", "customer_id", "due_date", "id", "movie_id"]
      end
    end

    it "returns 'no overdue movies' if none are overdue" do
      Rental.destroy_all
      get overdue_path
      check_response(expected_type: Hash, expected_status: :ok)
    end
  end
end

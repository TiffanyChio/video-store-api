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
  end
end

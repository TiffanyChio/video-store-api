require "test_helper"

describe Movie do
  let(:movie){movies(:one)}
  describe "validations" do
    
    
    it "can be valid" do
      assert movie.valid?
    end
    
    it "must have a title" do
      movie.title = ""
      refute movie.valid?
      expect(movie.errors.messages).must_include :title
      expect(movie.errors.messages[:title]).must_include "can't be blank"
    end
    
    it "must have a overview" do
      movie.overview = ""
      refute movie.valid?
      expect(movie.errors.messages).must_include :overview
      expect(movie.errors.messages[:overview]).must_include "can't be blank"
    end
    
    it "must have a release date" do 
      movie.release_date = ""
      refute movie.valid?
      expect(movie.errors.messages).must_include :release_date
      expect(movie.errors.messages[:release_date]).must_include "can't be blank"
    end
    
    it "must have an inventory" do
      movie.inventory = nil
      refute movie.valid?
      expect(movie.errors.messages).must_include :inventory
      expect(movie.errors.messages[:inventory]).must_include "can't be blank"
    end
  end
  
  describe "custom methods" do
    describe "decrease_inventory" do
      it "will decrease a movie's available inventory by 1" do
        before = movie.available_inventory
        movie.decrease_inventory
        expect(movie.available_inventory).must_equal before - 1
      end
    end
    
    describe "increase_inventory" do
      it "will increase a movie's available inventory by 1" do
        before = movie.available_inventory
        movie.increase_inventory
        expect(movie.available_inventory).must_equal before + 1
      end
    end
    
    describe "in_stock" do
      it "returns the Movie object when available inventory is not zero" do
        movie = movies(:two)
        
        expect(movie.in_stock).must_be_kind_of Movie
        expect(movie.title).must_equal "a second movie"
      end
      
      it "returns nil when there is no available inventory" do
        movie = movies(:two)
        movie.available_inventory = 0
        movie.save!
        
        expect(movie.available_inventory).must_equal 0
        
        expect(movie.in_stock).must_be_nil
      end
    end
    
    describe "find_curr_rentals" do
      CURR_RENT_FIELDS = [:check_out_date, :customer_id, :due_date, :name, :postal_code]
      
      it "returns an array of customers who have currently checked out a movie" do
        movie = movies(:star_wars)
        current_rentals = movie.find_curr_rentals
        
        expect(current_rentals).must_be_kind_of Array
        expect(current_rentals.length).must_equal 3
        expect(current_rentals.first).must_be_kind_of Hash
        expect(current_rentals.first.keys.sort).must_equal CURR_RENT_FIELDS
      end
      
      it "returns an empty array if no copies of a movie are currently checked out" do
        movie = movies(:unpopular)
        current_customers = movie.find_curr_rentals
        
        expect(current_customers).must_be_kind_of Array
        expect(current_customers.length).must_equal 0
      end
    end
    
    RENTAL_FIELDS = [:check_out_date, :customer_id, :due_date, :name, :postal_code]
    
    describe "find_curr_rentals" do
      it "returns an array of customers who have currently checked out a movie" do
        movie = movies(:star_wars)
        current_rentals = movie.find_curr_rentals
        
        expect(current_rentals).must_be_kind_of Array
        expect(current_rentals.length).must_equal 3
        expect(current_rentals.first).must_be_kind_of Hash
        expect(current_rentals.first.keys.sort).must_equal CURR_RENT_FIELDS
      end
      
      it "returns an empty array if no copies of a movie are currently checked out" do
        movie = movies(:unpopular)
        current_customers = movie.find_curr_rentals
        
        expect(current_customers).must_be_kind_of Array
        expect(current_customers.length).must_equal 0
      end
    end
    
    describe "find_past_rentals" do
      it "returns an array of customers who have currently checked out a movie" do
        movie = movies(:star_wars)
        current_rentals = movie.find_curr_rentals
        
        expect(current_rentals).must_be_kind_of Array
        expect(current_rentals.length).must_equal 3
        expect(current_rentals.first).must_be_kind_of Hash
        expect(current_rentals.first.keys.sort).must_equal CURR_RENT_FIELDS
      end
      
      it "returns an empty array if no copies of a movie are currently checked out" do
        movie = movies(:unpopular)
        current_customers = movie.find_curr_rentals
        
        expect(current_customers).must_be_kind_of Array
        expect(current_customers.length).must_equal 0
      end
    end
  end
end

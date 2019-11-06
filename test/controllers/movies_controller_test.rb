require "test_helper"

MOVIE_FIELDS = ["available_inventory", "id", "inventory", "overview", "release_date", "title"]

describe MoviesController do
  describe "index" do
    it "responds with JSON, success, and an array of movie hashes" do
      get movies_path
      
      check_response(expected_type: Array)
      
      body = JSON.parse(response.body)
      
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal MOVIE_FIELDS
      end
    end
    
    it "will respond with an empty array when there are no movies" do
      Movie.destroy_all
      
      get movies_path
      
      check_response(expected_type: Array)
      
      body = JSON.parse(response.body)
      expect(body).must_equal []
    end
  end
  
  describe "show" do
    it "responds with JSON, success, and info for one movie stored in a hash" do
      movie = movies(:three)
      
      get movie_path(id: movie.id)
      
      check_response(expected_type: Hash)
      
      body = JSON.parse(response.body)
      
      expect(body.keys.sort).must_equal ["available_inventory", "inventory", "overview", "release_date", "title"]
      expect(body["title"]).must_equal "Titanic"
    end
    
    it "responds with not found if the movie does not exist" do
      get movie_path(-1)
      
      check_response(expected_type: Hash, expected_status: :not_found)
      
      body = JSON.parse(response.body)
      
      expect(body.keys).must_include "errors"
    end
  end
  
  describe "create" do
    let(:movie_data){
      {
        "title" => "Happy Feet",
        "overview" => "A movie about cartoon penguins.",
        "release_date" => "2019-10-03",
        "inventory" => "5"
      }
    }
    
    it "can create a new movie" do
      expect {
        post movies_path, params: movie_data
      }.must_differ 'Movie.count', 1
      
      check_response(expected_type: Hash)
      
      body = JSON.parse(response.body)
      expect(body["id"]).must_be_instance_of Integer
    end
    
    it "will respond with bad_request and errors for invalid data" do
      movie_data["title"] = nil
      
      expect {
        post movies_path, params: movie_data
      }.wont_change 'Movie.count'
      
      check_response(expected_type: Hash, expected_status: :bad_request)
      
      body = JSON.parse(response.body)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "title"
    end
  end
end

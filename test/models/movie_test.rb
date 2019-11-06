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
end

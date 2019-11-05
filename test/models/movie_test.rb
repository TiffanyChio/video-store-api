require "test_helper"

describe Movie do
  describe "validations" do
    let(:movie){movies(:one)}
    
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
end

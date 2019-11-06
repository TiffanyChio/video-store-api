require "test_helper"

CUSTOMER_FIELDS = ["address", "city", "id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at", "state"]

describe CustomersController do
  describe "index" do
    it "responds with JSON, success, and an array of customer hashes" do
      get customers_path
      
      check_response(expected_type: Array)
      
      body = JSON.parse(response.body)
      
      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal CUSTOMER_FIELDS
      end
    end
    
    it "will respond with an empty array when there are no customers" do
      Customer.destroy_all
      
      get customers_path
      
      check_response(expected_type: Array)
      
      body = JSON.parse(response.body)
      expect(body).must_equal []
    end
  end
end

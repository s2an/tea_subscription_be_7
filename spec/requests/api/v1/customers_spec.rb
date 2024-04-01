# spec/requests/customers_spec.rb
require "rails_helper"

RSpec.describe "Customers", type: :request do
  describe "GET /customers/:id" do
    it "returns the customer" do
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")

      get api_v1_customer_path(customer)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(customer.first_name)
      expect(response.body).to include(customer.last_name)
      expect(response.body).to include(customer.email)
      expect(response.body).to include(customer.address)
    end
  end

  describe "POST /customers" do
    it "HAPPY PATH: creates a new customer" do
      customer_params = { customer: { first_name: "John", last_name: "Jane", email: "johnjane@test.com", address: "123 Main St" } }

      post api_v1_customers_path, params: customer_params

      expect(response).to have_http_status(:created)
      expect(Customer.count).to eq(1)
      expect(response.body).to include("John")
      expect(response.body).to include("Jane")
      expect(response.body).to include("johnjane@test.com")
      expect(response.body).to include("123 Main St")
    end
  end
end
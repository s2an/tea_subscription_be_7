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
end
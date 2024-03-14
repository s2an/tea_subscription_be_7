# spec/requests/subscriptions_spec.rb
require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  describe "GET /customers/:customer_id/subscriptions/:id" do
    it "returns all of the customer's subscriptions" do
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      tea = Tea.create!(title: "Green Tea", description: "Green tea lighter than Black Tea.", temperature: 180, brew_time: 5)
      subscription = Subscription.create!(title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", customer: customer, tea: tea)

      get api_v1_customer_subscriptions_path(customer)
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include(subscription.title)
      expect(response.body).to include(subscription.price.to_s)
      expect(response.body).to include(subscription.status)
      expect(response.body).to include(subscription.frequency)
    end
  end
end
# spec/requests/subscriptions_spec.rb
require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  describe "GET /customers/:customer_id/subscriptions" do
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

  describe "POST /customers/:customer_id/subscriptions" do
    it "HAPPY PATH: creates a new subscription for the customer" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params
# require "pry"; binding.pry
      expect(response).to have_http_status(:created)
      expect(customer.subscriptions.count).to eq(1)

      expect(response.body).to include("The Green Box")
      expect(response.body).to include("9.99")
      expect(response.body).to include("active")
      expect(response.body).to include("monthly")
    end

    it "SAD PATH: does not create a new subscription with incomplete params" do
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      incomplete_subscription_params = { subscription: { title: "The Green Box", price: 9.99 } }

      post api_v1_customer_subscriptions_path(customer), params: incomplete_subscription_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(customer.subscriptions.count).to eq(0)
    end
  end
end
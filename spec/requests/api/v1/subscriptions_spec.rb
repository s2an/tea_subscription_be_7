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
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params

      expect(response).to have_http_status(:created)
      expect(customer.subscriptions.count).to eq(1)

      expect(response.body).to include("The Green Box")
      expect(response.body).to include("9.99")
      expect(response.body).to include("active")
      expect(response.body).to include("monthly")
    end

    it "SAD PATH: does not create a new subscription with incomplete params" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      incomplete_subscription_params = { subscription: { title: "The Green Box", price: 9.99, tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: incomplete_subscription_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(customer.subscriptions.count).to eq(0)
    end
  end

  describe "DELETE /customers/:customer_id/subscriptions/:id" do
    it "HAPPY PATH: deletes a subscription from the customer" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params

      subscription = Subscription.last
      
      expect(Subscription.count).to eq(1)
  
      delete api_v1_customer_subscription_path(customer, subscription)
      expect(response).to be_successful
      expect(Subscription.count).to eq(0)
      expect{ Subscription.find(subscription.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  describe "DELETE /customers/:customer_id/subscriptions/:id" do
    it "SAD PATH: does NOT delete a subscription from the customer if the subscription id is not associated" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params

      subscription = Subscription.last
      
      expect(Subscription.count).to eq(1)

      delete api_v1_customer_subscription_path(customer, id: subscription.id + 1)

      expect(response).to have_http_status(:not_found)
    end

    it "SAD PATH: does NOT delete a subscription from the customer if the customer is not associated" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params

      subscription = Subscription.last
      
      expect(Subscription.count).to eq(1)

      wrong_customer = Customer.last.id + 1
      delete api_v1_customer_subscription_path(customer_id: wrong_customer, id: subscription)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /customers/:customer_id/subscriptions/:id" do
    it "CANCELS a subscription from the customer" do
      tea = Tea.create!(title: "Green Tea", description: "Green tea is lighter than Black Tea.", temperature: 180, brew_time: 5)
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      subscription_params = { subscription: { title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", tea_id: tea.id } }
      deactivate_subscription_params = { subscription: { status: "cancelled" } }

      post api_v1_customer_subscriptions_path(customer), params: subscription_params

      subscription = Subscription.last
      
      expect(Subscription.count).to eq(1)
  
      patch api_v1_customer_subscription_path(customer, subscription), params: deactivate_subscription_params

      expect(response).to be_successful
      expect(Subscription.count).to eq(1)
      expect(Subscription.last.status).to eq("cancelled")       
      end
    end

  describe "GET /customers/:customer_id/subscriptions" do
    it "active and cancelled: returns all of the customer's subscriptions" do
      customer = Customer.create!(first_name: "Jane", last_name: "Doe", email: "jane.doe@anyominous.com", address: "123 Main St")
      tea_1 = Tea.create!(title: "Green Tea", description: "Green tea lighter than Black Tea.", temperature: 180, brew_time: 5)
      tea_2 = Tea.create!(title: "Black Tea", description: "Black tea darker than Green Tea.", temperature: 220, brew_time: 10)
      subscription = Subscription.create!(title: "The Green Box", price: 9.99, status: "active", frequency: "monthly", customer: customer, tea: tea_1)
      subscription = Subscription.create!(title: "The Black Box", price: 19.99, status: "cancelled", frequency: "monthly", customer: customer, tea: tea_2)

      get api_v1_customer_subscriptions_path(customer)
      
      expect(response.body).to include("The Green Box")
      expect(response.body).to include("active")
      expect(response.body).to include("The Black Box")
      expect(response.body).to include("cancelled")
    end
  end
end
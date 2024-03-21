class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subscriptions = customer.subscriptions
    render json: subscriptions
  end

  def create
    customer = Customer.find(params[:customer_id])
    subscription = customer.subscriptions.create(subscription_params)
    
    if subscription.save
      render json: subscription, status: :created
    else
      render json: subscription.errors, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency)
  end

end
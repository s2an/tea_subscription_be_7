class Api::V1::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subscriptions = customer.subscriptions
    render json: subscriptions
  end

  def create
    customer = Customer.find(params[:customer_id])
    tea = Tea.find(subscription_params[:tea_id])
    subscription = customer.subscriptions.create!(subscription_params)
    subscription.tea = tea
    
    if subscription.save
      render json: subscription, status: :created
    else
      render json: subscription.errors, status: :unprocessable_entity
    end
  end

  def update
    subscription = Subscription.find(params[:id])
    if params[:subscription][:status] == "cancelled"
      subscription.update(status: "cancelled")
      render json: subscription, status: :ok
    else
      render json: subscription.errors, status: :unprocessable_entity
    end
  end

  def destroy
    customer = Customer.find(params[:customer_id])
    subscription = Subscription.find(params[:id])
    subscription.destroy!
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id)
  end

end
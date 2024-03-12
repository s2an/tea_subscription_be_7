class Api::V1::CustomersController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    render json: customer
  end
end
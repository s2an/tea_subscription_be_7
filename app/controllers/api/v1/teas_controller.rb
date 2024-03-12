class Api::V1::TeasController < ApplicationController
  def show
    tea = Tea.find(params[:id])
    render json: tea
  end
end
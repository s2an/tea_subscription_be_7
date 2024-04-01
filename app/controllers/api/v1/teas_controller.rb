class Api::V1::TeasController < ApplicationController

  def create
    tea = Tea.new(tea_params)
    if tea.save
      render json: tea, status: :created
    else
      render json: tea.errors, status: :unprocessable_entity
    end
  end

  def show
    tea = Tea.find(params[:id])
    render json: tea
  end

  private

  def tea_params
    params.require(:tea).permit(:title, :description, :temperature, :brew_time)
  end
end
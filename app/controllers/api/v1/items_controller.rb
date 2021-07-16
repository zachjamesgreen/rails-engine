class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: {
      count: items.size,
      items:items 
    }
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item
    else
      render json: {errors: item.errors}, status: 422
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item
    else
      render json: {errors: item.errors}, status: 422
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
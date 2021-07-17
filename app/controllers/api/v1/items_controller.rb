class Api::V1::ItemsController < ApplicationController
  def index
    page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    per_page = params[:per_page].to_i == 0 ? 20 : params[:per_page].to_i
    items = Item.page(page).per(per_page)
    render json: items
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
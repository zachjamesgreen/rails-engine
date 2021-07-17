class Api::V1::ItemsController < ApplicationController
  def index
    page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    per_page = params[:per_page].to_i.zero? ? 20 : params[:per_page].to_i
    items = Item.page(page).per(per_page)
    render json: items
  end

  def show
    render json: Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      message: 'Not Found',
      errors: ["Could not find item with id => #{params[:id]}"]
    }, status: :not_found
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: {
        message: 'Invalid',
        errors: item.errors.map { |_attr, msg| msg }
      }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item
    else
      render json: { message: 'Invalid', errors: item.errors.map { |_attr, msg| msg } }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Not Found', errors: ["Can not find item with id => #{params[:id]}"] }, status: :not_found
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: {
      message: 'Not Found',
      errors: ["Can not find item with id => #{params[:id]}"]
    }, status: :not_found
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end

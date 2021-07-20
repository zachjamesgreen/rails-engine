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
    not_found(["Could not find item with id => #{params[:id]}"])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item, status: :created
    else
      cannot_process(item.errors.map { |_attr, msg| msg })
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: item
    else
      cannot_process(item.errors.map { |_attr, msg| msg })
    end
  rescue ActiveRecord::RecordNotFound
    not_found(["Can not find item with id => #{params[:id]}"])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy_solo_invoices
    item.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    not_found(["Can not find item with id => #{params[:id]}"])
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end

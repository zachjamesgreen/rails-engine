class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    items = Merchant.find(params[:merchant_id]).items
    render json: items
  rescue ActiveRecord::RecordNotFound
    not_found(["Could not find Merchant by this id => #{params[:merchant_id]}"])
  end
end

class Api::V1::Items::MerchantController < ApplicationController
  def index
    render json: Item.find(params[:item_id]).merchant
  rescue ActiveRecord::RecordNotFound
    not_found(["Can not find item with id => #{params[:item_id]}"])
  end
end

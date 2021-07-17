class Api::V1::Items::MerchantsController < ApplicationController
  def index
    render json: Item.find(params[:item_id]).merchant
  rescue ActiveRecord::RecordNotFound
    render json: {
      message: 'Not Found',
      errors: ["Can not find item with id => #{params[:item_id]}"]
    }, status: :not_found
  end
end

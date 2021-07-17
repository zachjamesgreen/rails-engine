class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    begin
      items = Merchant.find(params[:merchant_id]).items
    render json: items
    rescue ActiveRecord::RecordNotFound
      render json: {
        message: "Not Found",
        errors: ["Could not find Merchant by this id => #{params[:merchant_id]}"]
      }, status: 404
    end
  end
end
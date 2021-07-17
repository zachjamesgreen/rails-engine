class Api::V1::MerchantsController < ApplicationController
  def index
    page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    per_page = params[:per_page].to_i == 0 ? 20 : params[:per_page].to_i

    render json: Merchant.page(page).per(per_page)
  end

  def show
    begin
      merchant = Merchant.find(params[:id])
      render json: merchant
    rescue ActiveRecord::RecordNotFound
      render json: {
        message: 'Not Found',
        errors: ["Could not find Merchant by this id => #{params[:id]}"]
      }, status: 404
    end
  end
end
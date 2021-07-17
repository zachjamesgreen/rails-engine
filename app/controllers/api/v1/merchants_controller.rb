class Api::V1::MerchantsController < ApplicationController
  def index
    page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    per_page = params[:per_page].to_i == 0 ? 20 : params[:per_page].to_i

    render json: Merchant.page(page).per(per_page)
  end

  private
end
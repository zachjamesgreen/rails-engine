class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: Merchant.search(params[:q]).limit(1)
  end
end
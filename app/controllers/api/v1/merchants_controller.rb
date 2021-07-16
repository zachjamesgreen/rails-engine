class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all

    render json: {
      count: merchants.size,
      merchants: merchants
    }
  end
end
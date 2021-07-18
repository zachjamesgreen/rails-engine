class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name].present?
      if (merchant = Merchant.search(params[:name]).first)
        render json: merchant
      else
        not_found(["No Merchant was found for your search => #{params[:name]}"])
      end
    else
      cannot_process(['Name must be present to search'])
    end
  end

  def find_all; end
end

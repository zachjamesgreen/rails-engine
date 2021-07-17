class Api::V1::Merchants::SearchController < ApplicationController
  def find
    # if params[:name].present?
    #   render json: Merchant.search(params[:q]).limit(1)
    # else
    #   render json: {
    #     message: 'Please provide a name',
    #     errors: [
    #       'Name must be present to search'
    #     ]
    #   }, status: :unprocessable_entity
    # end
  end

  def find_all; end
end

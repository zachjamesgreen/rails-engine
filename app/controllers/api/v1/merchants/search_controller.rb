class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name].present?
      merchant = Merchant.search(params[:name]).first
      if merchant
        render json: merchant
      else
        render json: {
          message: 'Not Found',
          errors: ['No Merchant was found for your search => ' + params[:name]]
        }, status: 404
      end
    else
      render json: {
        message: 'Please provide a name',
        errors: [
          'Name must be present to search'
        ]
      }, status: :unprocessable_entity
    end
  end

  def find_all; end
end

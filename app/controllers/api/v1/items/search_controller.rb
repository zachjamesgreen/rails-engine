class Api::V1::Items::SearchController < ApplicationController
  def find; end

  def find_all
    if params.fetch(:name, nil) && (params.fetch(:min_price, nil) || params.fetch(:max_price, nil))
      ap '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
      render json: {
        message: 'Can not process',
        errors: ['You must provide either name or min/max price']
      },status: :unprocessable_entity and return
    end

    if params.fetch(:name, nil)
      if params[:name] == ''
        render json: {
          message: 'Can not process',
          errors: ['name must be present']
        },status: :unprocessable_entity and return
      end
      items = Item.search_name(params[:name])
      if items.empty?
        render json: {
          message: 'Not Found',
          errors: ["Can not find item with #{params[:name]} in name"]
        },status: :not_found and return
      else
        render json: items and return
      end
    end

    if params.fetch(:min_price, nil) || params.fetch(:max_price, nil)
      if params[:min_price] == '' && params[:max_price] == '' 
        render json: {
          message: 'Can not process',
          errors: ['min/max price must be present']
        },status: :unprocessable_entity and return
      end

      if params[:max_price] && params[:max_price].to_i == 0
        render json: {
          message: 'Can not process',
          errors: ["max price must be numeric and not 0. you sent => #{params[:max_price]}"]
        },status: :unprocessable_entity and return
      end
      items = Item.search_price(min: params[:min_price].to_i, max: params[:max_price])
      if items.empty?
        render json: {
          message: 'Not Found',
          errors: ["Can not find items with price between #{params[:min_price].to_i} and #{params[:max_price].to_i}"]
        },status: :not_found and return
      else
        render json: items and return
      end
    end

    render json: {
      message: 'Can not process',
      errors: ['name must be present', 'min/max price must be present']
    },status: :unprocessable_entity and return

  end
end

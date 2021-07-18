class Api::V1::Items::SearchController < ApplicationController
  def find; end

  def find_all
    # can only have name or min/max price
    check_for_incompatible_params; return if performed?

    if params[:name].present?
      items = Item.search_name(params[:name])
      not_found(["Can not find item with #{params[:name]} in name"]) and return if items.empty?
      render json: items and return
    end

    if params[:min_price].present? || params[:max_price].present?
      # checks to see if maxprice is not 0
      check_max_price; return if performed?

      items = Item.search_price(min: params[:min_price].to_i, max: params[:max_price])
      if items.empty?
        not_found(["Can not find items with price between #{params[:min_price].to_i} and #{params[:max_price].to_i}"]) and return
      end

      render json: items and return
    end
    cannot_process(['name must be present', 'min/max price must be present']) and return
  end

  private

  def check_max_price
    if params[:max_price] && params[:max_price].to_i.zero?
      cannot_process(["max price must be numeric and not 0. you sent => #{params[:max_price]}"]) and return
    end
  end

  def check_for_incompatible_params
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      cannot_process(['You must provide either name or min/max price']) and return
    end
  end
end

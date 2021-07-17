class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.search(params[:q])
    render json: items
  end
end

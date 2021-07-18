class Api::V1::RevenueController < ApplicationController
  def merchant_total_revenue
    @merchant = Merchant.find(params[:id])
    render_revenue and return
  rescue ActiveRecord::RecordNotFound
    errors = ["Can not find merchant with id => #{params[:id]}"]
    if params[:id].to_i.to_s != params[:id]
      errors.push('id must be an integer')
      cannot_process(errors) and return
    end
    not_found(errors)
  end

  private

  def render_revenue
    render json: {
      data: {
        id: @merchant.id.to_s,
        type: 'merchant_revenue',
        attributes: {
          revenue: @merchant.revenue
        }
      }
    }
  end
end

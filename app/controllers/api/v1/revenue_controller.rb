class Api::V1::RevenueController < ApplicationController
  def merchant_total_revenue
    @merchant = Merchant.find(params[:id])
    render json: Merchant.find(params[:id]), serializer: MerchantRevenueSerializer
  rescue ActiveRecord::RecordNotFound
    errors = ["Can not find merchant with id => #{params[:id]}"]
    if param_is_integer(params[:id])
      errors.push('id must be an integer')
      cannot_process(errors) and return
    end
    not_found(errors)
  end

  def item_ranked_revenue
    cannot_process(['quantity must be an integer and not 0']) and return if param_is_integer(params[:quantity])

    quantity = params[:quantity] || 10
    render json: Item.ranked_revenue(quantity), each_serializer: ItemRevenueSerializer
  end

  def unshipped_revenue
    if params[:quantity] && params[:quantity].to_i <= 0
      cannot_process(['quantity must be an integer and not 0']) and return
    end
    quantity = params[:quantity] || 10
    render json: Invoice.ranked_revenue_unshipped(quantity), each_serializer: InvoiceUnshippedRevenueSerializer
  end

  def weekly_revenue
    render json: Invoice.weekly_revenue, each_serializer: InvoiceWeeklyRevenueSerializer
  end
end

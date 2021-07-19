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

  def item_ranked_revenue
    if params[:quantity] && params[:quantity].to_i <= 0
      cannot_process(['quantity must be an integer and not 0']) and return
    end
    quantity = params[:quantity] || 10
    render json: Item.ranked_revenue(quantity), type: 'item_revenue'
  end

  def unshipped_revenue
    if params[:quantity] && params[:quantity].to_i <= 0
      cannot_process(['quantity must be an integer and not 0']) and return
    end
    quantity = params[:quantity] || 10
    render json: Invoice.ranked_revenue_unshipped(quantity)
  end

  def weekly_revenue
    sql = "SELECT week, sum(total) from (
      SELECT  date_trunc('week', invoices.created_at)::date as week, sum(invoice_items.quantity * invoice_items.unit_price) as total FROM invoices
    INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id
    INNER JOIN transactions ON transactions.invoice_id = invoices.id
    WHERE (transactions.result = 'success' and invoices.status = 'shipped')
    GROUP BY week, invoices.created_at
    ) as t
    group by t.week
    ORDER BY t.week asc;"
    results = ActiveRecord::Base.connection.execute(sql)
    res = {
      data: results.map do |result|
          {
            id: nil,
            type: 'weekly_revenue',
            attributes: {
              week: result['week'],
              revenue: result['sum']
            }
          }
      end
    }
    render json: res
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

class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  def self.ranked_revenue_unshipped(quantity = 10)
    all
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as potential_revenue')
      .joins(:transactions)
      .joins(:invoice_items)
      .where("transactions.result = 'success' and invoices.status = 'packaged'")
      .group('invoices.id')
      .order('potential_revenue desc')
      .limit(quantity)
  end

  def self.weekly_revenue
    all
      .select("date_trunc('week', invoices.created_at)::date as week, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
      .joins("INNER JOIN invoice_items ON invoice_items.invoice_id = invoices.id and invoices.status = 'shipped'")
      .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
      .group('week')
      .order('week asc')
  end
end

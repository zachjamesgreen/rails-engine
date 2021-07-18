class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  def self.search(query)
    order(:name).where('name ILIKE ?', "%#{query}%")
  end

  def revenue
    invoices
      .joins(:transactions)
      .joins(:invoice_items)
      .where("transactions.result = 'success' and invoices.status = 'shipped'")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end

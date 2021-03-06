class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  validates :name, presence: { message: 'Can not create item without a name' }
  validates :merchant_id, presence: { message: 'Can not create item without a merchant id' }
  validates :unit_price, presence: { message: 'Can not create item without a unit price' }
  validates :merchant, presence: { message: 'Merchant not found. Can not create item without a merchant' }
  validates :unit_price, numericality: { message: 'Unit price must be numeric' }

  def self.search_name(name)
    # where('name ILIKE ?', "%#{name}%")
    where('name ILIKE ? or description ILIKE ?', "%#{name}%", "%#{name}%")
  end

  def self.search_price(min:, max:)
    min ||= 0
    max = max.zero? ? Float::INFINITY : max
    where(unit_price: min..max)
  end

  def self.ranked_revenue(quantity = 10)
    all
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .joins('INNER JOIN invoice_items ON invoice_items.item_id = items.id')
      .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id and invoices.status = 'shipped'")
      .joins("INNER JOIN transactions ON transactions.invoice_id = invoices.id and transactions.result = 'success'")
      .group('items.id')
      .order('revenue desc')
      .limit(quantity)
  end

  def self.ranked_revenue_unshipped(quantity = 10)
    all
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .joins(invoices: :transactions)
      .joins(:invoice_items)
      .where("transactions.result = 'success' and invoices.status = 'packaged'")
      .group('items.id')
      .order('revenue desc')
      .limit(quantity)
  end

  def destroy_solo_invoices
    invoices.each do |inv|
      inv.destroy if inv.items.size == 1
    end
  end

  def revenue_total
    invoices
      .joins(:transactions)
      .joins(:invoice_items)
      .where("transactions.result = 'success' and invoices.status = 'shipped'")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end

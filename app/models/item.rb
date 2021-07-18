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
    where('name ILIKE ?', "%#{name}%")
  end

  def self.search_price(min:, max:)
    min ||= 0
    max = max.to_i.zero? ? Float::INFINITY : max.to_i
    where(unit_price: min..max)
  end

  def destroy_solo_invoices
    invoices.each do |inv|
      inv.destroy if inv.items.size == 1
    end
  end

end

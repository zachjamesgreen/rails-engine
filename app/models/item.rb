class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  validates_presence_of :name, message: 'Can not create item without a name'
  validates_presence_of :merchant_id, message: 'Can not create item without a merchant id'
  validates_presence_of :unit_price, message: 'Can not create item without a unit price'
  validates_presence_of :merchant, message: 'Merchant not found. Can not create item without a merchant'
  validates_numericality_of :unit_price, greater_than_or_equal_to: 0, message: 'Unit price must be numeric'

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end
end
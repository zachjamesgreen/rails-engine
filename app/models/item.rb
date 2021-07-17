class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  validates :name, presence: { message: 'Can not create item without a name' }
  validates :merchant_id, presence: { message: 'Can not create item without a merchant id' }
  validates :unit_price, presence: { message: 'Can not create item without a unit price' }
  validates :merchant, presence: { message: 'Merchant not found. Can not create item without a merchant' }
  validates :unit_price, numericality: { message: 'Unit price must be numeric' }

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end
end

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end
end
class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end
end

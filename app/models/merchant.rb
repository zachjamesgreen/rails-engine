class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end
end
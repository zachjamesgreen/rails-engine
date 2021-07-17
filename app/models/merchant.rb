class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  def self.search(query)
    where('name ILIKE ?', "%#{query}%")
  end

  def self.per(per_page)
    per_page ||= 20
    offset = @page * per_page
    return [] if @page != 0 && (self.count / @page) < 1
    return self.all if offset >= self.count
    self.limit(per_page).offset(offset)
  end

  def self.page(page)
    @page = (page.to_i - 1)
    return self
  end
end

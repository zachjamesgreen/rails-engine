class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  def merchant
    item.merchant
  end
end

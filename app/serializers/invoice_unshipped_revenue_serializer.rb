class InvoiceUnshippedRevenueSerializer < ActiveModel::Serializer
  type :unshipped_order
  attributes :id, :potential_revenue
end

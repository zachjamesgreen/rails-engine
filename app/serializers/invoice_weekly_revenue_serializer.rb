class InvoiceWeeklyRevenueSerializer < ActiveModel::Serializer
  type :weekly_revenue
  attribute(:id) { nil }
  attributes :week, :revenue
end
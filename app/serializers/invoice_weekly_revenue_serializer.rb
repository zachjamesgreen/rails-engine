class InvoiceWeeklyRevenueSerializer < ActiveModel::Serializer
  type :weekly_revenue
  attributes :week, :revenue
  attribute(:id) do
    object.id
  end
end

class MerchantRevenueSerializer < ActiveModel::Serializer
  type :merchant_revenue
  attributes :id, :revenue
end

class ItemRevenueSerializer < ActiveModel::Serializer
  type :item_revenue
  attributes :id, :name, :description, :unit_price, :merchant_id, :revenue
end
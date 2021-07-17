class ItemSerializer < ActiveModel::Serializer
  type :item
  attributes :id, :name, :description, :unit_price, :merchant_id
end

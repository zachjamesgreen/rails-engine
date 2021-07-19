class ItemSerializer < ActiveModel::Serializer
  type :item
  attributes :id, :name, :description, :unit_price, :merchant_id
  attribute :revenue, if: :revenue_present?

  def revenue_present?
    object.revenue.present?
  end
end

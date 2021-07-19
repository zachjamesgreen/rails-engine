class InvoiceSerializer < ActiveModel::Serializer
  type :invoice
  attributes :id
  attribute :potential_revenue, if: :potential_revenue_present?

  def potential_revenue_present?
    object.potential_revenue.present?
  end
    
end

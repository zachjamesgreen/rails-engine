require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it {should belong_to(:customer)}
  it {should belong_to(:merchant)}
  it {should have_many(:invoice_items)}
  it {should have_many(:transactions)}

  context 'methods' do
    it 'weekly revenue' do
      d1,d2,d3,d4 = [
        Date.parse('Mon, 21 Jun 2021'), Date.parse('Mon, 28 Jun 2021'),
        Date.parse('Mon, 05 Jul 2021'), Date.parse('Mon, 12 Jul 2021')
      ]
      i1 = create(:invoice, created_at: d1,  status: 'shipped')
      i2 = create(:invoice, created_at: d2, status: 'shipped')
      i3 = create(:invoice, created_at: d3, status: 'shipped')
      i4 = create(:invoice, created_at: d4, status: 'shipped')

      [i1,i2,i3,i4].each_with_index do |i, idx|
        items = create_list(:item, 5, unit_price: 10+idx)
        items.each_with_index do |item, idy|
          create(:invoice_item, invoice: i, item: item, quantity: 1+idy)
        end
        create(:transaction, invoice: i, result: 'success')
      end

      wr = Invoice.weekly_revenue.map {|wr| [wr.week, wr.revenue]}
      expect(wr).to match_array([[d1, 150], [d2, 165], [d3, 180], [d4, 195]])


    end
  end
end
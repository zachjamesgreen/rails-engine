require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a valid factory' do
    expect(create(:item)).to be_valid
  end

  it {should belong_to(:merchant)}
  it {should have_many(:invoice_items)}

  it {should validate_presence_of(:name).with_message('Can not create item without a name') }
  it {should validate_presence_of(:merchant_id).with_message('Can not create item without a merchant id') }
  it {should validate_presence_of(:unit_price).with_message('Can not create item without a unit price') }
  it {should validate_numericality_of(:unit_price).with_message('Unit price must be numeric') }
  it {should validate_presence_of(:merchant).with_message('Merchant not found. Can not create item without a merchant') }

  context 'methods' do
    def create_item(invoice_status, invoice_item_status)
      item = create(:item, unit_price: 10)
      create_list(:invoice, 10, status: invoice_status).each do |invoice|
        create(:invoice_item, item: item, invoice: invoice, quantity: 1)
        create(:transaction, invoice: invoice, result: invoice_item_status)
      end
      item
    end

    context 'revenue' do
      it 'revenue' do
        item = create_item('shipped', 'success')
        expect(item.revenue_total).to eq(100)
        expect(item.revenue_total).to be_instance_of(Float)
      end
  
      it 'doesnt include not shipped invoices' do
        item = create_item('returned', 'success')
        expect(item.revenue_total).to eq(0)
      end
  
      it 'doesnt include unsuccessful transactions' do
        item = create_item('shipped', 'failed')
        expect(item.revenue_total).to eq(0)
      end
  
      it 'doesnt include both unsuccessful transactions and not shipped invoices' do
        item = create_item('packaged', 'failed')
        expect(item.revenue_total).to eq(0)
      end
    end

    context 'ranked_revenue_unshipped' do
      it 'returns ranked_revenue_unshipped' do
        items = create_list(:item, 20, unit_price: 10).each_with_index do |item, idx|
          invoice = create(:invoice, status: 'packaged')
          create(:invoice_item, item: item, invoice: invoice, quantity: 1+idx)
          create(:transaction, invoice: invoice, result: 'success')
        end

        ranked_revenue = Item.ranked_revenue_unshipped
        expect(ranked_revenue.to_a.size).to eq(10)
        expect(ranked_revenue.first.revenue).to eq(200)
        expect(ranked_revenue.last.revenue).to eq(110)
        ranked_revenue = Item.ranked_revenue_unshipped(15)
        expect(ranked_revenue.to_a.size).to eq(15)

      end
    end
  end
end
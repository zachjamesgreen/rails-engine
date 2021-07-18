require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it 'has a valid factory' do
    expect(create(:merchant)).to be_valid
  end

  it {should have_many(:invoices)}
  it {should have_many(:items)}

  context 'merchant revenue' do
    it 'returns the revenue for a given merchant' do
      merchant = create(:merchant)
      # create successful transactions and shipped invoices
      invoice = create(:invoice, merchant: merchant, status: 'shipped')
      items = create_list(:item, 10, merchant: merchant, unit_price: 10)
      items.each do |item|
        create(:invoice_item, invoice: invoice, item: item, quantity: 10)
      end
      create(:transaction, invoice: invoice, result: 'success')
      expect(merchant.revenue).to eq(1000)
    end

    it 'doesnt include unsuccessful transactions' do
      merchant = create(:merchant)
      # create failed transactions and shipped invoices
      invoice = create(:invoice, merchant: merchant, status: 'shipped')
      create(:invoice_item, invoice: invoice, quantity: 10)
      create(:transaction, invoice: invoice, result: 'failed')
      expect(merchant.revenue).to eq(0)
    end

    it 'doesnt include not shipped items' do
      merchant = create(:merchant)
      # create successful transactions and not shipped invoices
      invoice = create(:invoice, merchant: merchant, status: 'packaged')
      create(:invoice_item, invoice: invoice, quantity: 10)
      create(:transaction, invoice: invoice, result: 'success')
      expect(merchant.revenue).to eq(0)
    end
  end

end
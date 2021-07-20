require 'rails_helper'

RSpec.describe 'Routes for BI - ItemsRankedRevenue' do
  def items_with_revenue
    merchant = create(:merchant)
    items = create_list(:item, 50, merchant: merchant, unit_price: 10)
    items.each_with_index do |item, idx|
      invoice = create(:invoice, merchant: merchant, status: 'shipped')
      create(:invoice_item, invoice: invoice, item: item, quantity: idx+10)
      create(:transaction, invoice: invoice, result: 'success')
    end
  end

  context 'ranked_revenue' do
    it 'returns 10 items by default ranked by revenue' do
      items = items_with_revenue
      get '/api/v1/revenue/items'
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      data = body['data']
      expect(data[0]['type']).to eq 'item_revenue'
      expect(data.size).to eq(10)
      expect(data[0]['attributes']['revenue']).to eq(items.last.revenue_total)
    end
  
    it 'returns given # of items' do
      num = rand(0..50)
      items = items_with_revenue
      get '/api/v1/revenue/items', params: { quantity: num }
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      data = body['data']
      expect(data.size).to eq(num)
    end
  
    it '# must be numeric and not 0' do
      get '/api/v1/revenue/items', params: { quantity: 'asda' }
      expect(response.status).to eq(400)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Can not process')
      expect(body['error']).to include('quantity must be an integer and not 0')
    end
  end

  context 'potential revenue' do
    it 'returns potential revenue. items that are packed and transaction is successful' do
      merchant = create(:merchant)
      items = create_list(:item, 12, merchant: merchant, unit_price: 10)
      items.each_with_index do |item, idx|
        invoice = create(:invoice, merchant: merchant, status: 'packaged')
        create(:invoice_item, invoice: invoice, item: item, quantity: idx+10)
        create(:transaction, invoice: invoice, result: 'success')
      end
      invoices = Invoice.ranked_revenue_unshipped
      get '/api/v1/revenue/unshipped'
      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      data = body['data']
      expect(data[0]['type']).to eq 'unshipped_order'
      expect(data.size).to eq(10)
      expect(data[0]['attributes']['potential_revenue']).to eq(invoices.first.potential_revenue)
    end
  
    it '# must be numeric and not 0' do
      get '/api/v1/revenue/unshipped', params: { quantity: 'asda' }
      expect(response.status).to eq(400)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Can not process')
      expect(body['error']).to include('quantity must be an integer and not 0')
    end
  end

end



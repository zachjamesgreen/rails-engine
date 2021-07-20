require 'rails_helper'

RSpec.describe "Routes: BI_routes" do

  def merchant_with_revenue
    merchant = FactoryBot.create(:merchant)
    invoice = create(:invoice, merchant: merchant, status: 'shipped')
    items = create_list(:item, 10, merchant: merchant)
    items.each do |item|
      create(:invoice_item, invoice: invoice, item: item)
    end
    create(:transaction, invoice: invoice, result: 'success')
    merchant
  end

  it 'returns total revenue for a given merchant' do
    merchant = merchant_with_revenue
    get "/api/v1/revenue/merchants/#{merchant.id}"
    expect(response).to be_successful
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(merchant.id.to_s)
    expect(body['data']['type']).to eq('merchant_revenue')
    expect(body['data']['attributes']['revenue']).to eq(merchant.revenue)
  end

  it 'returns 0.0 if merchant has no revenue' do
    merchant = create(:merchant)
    get "/api/v1/revenue/merchants/#{merchant.id}"
    expect(response).to be_successful
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq(merchant.id.to_s)
    expect(body['data']['type']).to eq('merchant_revenue')
    expect(body['data']['attributes']['revenue']).to eq(merchant.revenue)
  end

  it 'returns 404 error if merchant is not found' do
    get "/api/v1/revenue/merchants/345"
    expect(response).to be_not_found
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Not Found')
    expect(body['error']).to include('Can not find merchant with id => 345')
  end

  it 'returns 400 error if id is string' do
    get "/api/v1/revenue/merchants/abc"
    expect(response).to be_bad_request
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Can not process')
    expect(body['error']).to include('id must be an integer')
  end
end
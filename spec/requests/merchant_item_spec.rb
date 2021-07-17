require 'rails_helper'

RSpec.describe 'Item Merchant API' do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

  it 'returns merchant for given item' do
    get "/api/v1/items/#{@item.id}/merchants"
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    data = body['data']
    expect(data['id']).to eq(@merchant.id.to_s)
    expect(data['attributes']['name']).to eq(@merchant.name)
  end

  it 'returns 404 for non-existent item' do
    get '/api/v1/items/454/merchants'
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with id => 454')
  end
end
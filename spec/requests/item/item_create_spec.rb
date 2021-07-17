require 'rails_helper'

RSpec.describe 'Create Item API' do
  before(:all) { @merchant = create(:merchant) }
  it 'must have merchant_id, name, and unit_price' do
    post '/api/v1/items', params: {}
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include('Can not create item without a merchant id')
    expect(body['errors']).to include('Can not create item without a name')
    expect(body['errors']).to include('Can not create item without a unit price')
  end

  it 'returns error if unit_price is not numeric' do
    post '/api/v1/items', params: {
      merchant_id: @merchant.id,
      name: 'test',
      unit_price: 'test'
    }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to match_array(['Unit price must be numeric'])
    expect(Item.count).to eq 0
  end

  it 'returns error if merchant is not found' do
    post '/api/v1/items', params: {
      merchant_id: 56,
      name: 'test',
      unit_price: 57.05
    }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include('Merchant not found. Can not create item without a merchant')
    expect(Item.count).to eq 0
  end

  it 'can create an item and returns the item and 201 status' do
    post '/api/v1/items', params: {
      merchant_id: @merchant.id,
      name: 'test',
      unit_price: 7.09
    }
    expect(response.status).to eq(201)
    body = JSON.parse(response.body)
    item = Item.find(body['data']['id'])
    expect(body['data']['attributes']['name']).to eq item.name
    expect(body['data']['attributes']['description']).to eq item.description
    expect(body['data']['attributes']['unit_price']).to eq item.unit_price
    expect(body['data']['attributes']['merchant_id']).to eq item.merchant_id
  end
end
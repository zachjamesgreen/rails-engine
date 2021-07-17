require 'rails_helper'

RSpec.describe 'Edit Item API' do
  before(:each) { @item = create(:item) }

  it 'returns error(s) if name is blank' do
    put "/api/v1/items/#{@item.id}", params: { name: '' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include 'Can not create item without a name'
  end

  it 'returns error(s) if unit_price is blank' do
    put "/api/v1/items/#{@item.id}", params: { unit_price: '' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include 'Can not create item without a unit price'
  end

  it 'returns error(s) if unit_price is not numeric' do
    put "/api/v1/items/#{@item.id}", params: { unit_price: 'fdsfds' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include 'Unit price must be numeric'
  end

  it 'returns error(s) if merchant_id is blank' do
    put "/api/v1/items/#{@item.id}", params: { merchant_id: '' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include 'Can not create item without a merchant id'
  end

  it 'returns error(s) if merchant cant be found' do
    put "/api/v1/items/#{@item.id}", params: { merchant_id: 546 }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Invalid'
    expect(body['errors']).to include 'Merchant not found. Can not create item without a merchant'
  end

  it 'returns error if item cant be found' do
    put "/api/v1/items/57", params: { name: 'test edit' }
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Not Found'
    expect(body['errors']).to include 'Can not find item with id => 57'
  end

  it 'edits and returns the item' do
    merchant = create(:merchant)
    put "/api/v1/items/#{@item.id}", params: { name: 'test edit', description: 'test description', unit_price: 1000.0, merchant_id: merchant.id }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq @item.id.to_s
    expect(body['data']['attributes']['name']).to eq 'test edit'
    expect(body['data']['attributes']['description']).to eq 'test description'
    expect(body['data']['attributes']['unit-price']).to eq 1000.0
    expect(body['data']['attributes']['merchant-id']).to eq merchant.id
    expect(body['data']['attributes']['merchant-id']).to_not eq @item.merchant_id
  end
end
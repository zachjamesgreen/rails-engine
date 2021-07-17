require 'rails_helper'

RSpec.describe 'Item API' do
  before(:all) { create_list(:item, 5) }

  it 'returns 1 item' do
    item = Item.first
    get "/api/v1/items/#{item.id}"
    expect(response).to be_successful
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq item.id.to_s
    attrs = body['data']['attributes']
    expect(attrs['name']).to eq item.name.to_s
    expect(attrs['description']).to eq item.description
    expect(attrs['unit_price']).to eq item.unit_price
    expect(attrs['merchant_id']).to eq item.merchant_id
  end

  it 'returns a 404 if the item does not exist' do
    get '/api/v1/items/0'
    expect(response.status).to eq 404
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Not Found'
    expect(body['errors']).to match_array 'Could not find item with id => 0'
  end
end
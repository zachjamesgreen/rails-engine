require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  before(:all) do
    @merchants = create_list(:merchant, 2)
    @merchants.first.items << create_list(:item, 5, merchant: @merchants.first)
  end

  it 'returns merchant items' do
    id = @merchants[0].id
    items = @merchants[0].items
    get "/api/v1/merchants/#{id}/items"
    body = JSON.parse(response.body)
    data = body['data']
    expect(response).to be_successful
    expect(data.length).to eq(items.length)
    expect(data[0]['id'].to_i).to eq (items[0].id)
    expect(data[0]['attributes']['name']).to eq (items[0].name)
    expect(data[0]['attributes']['description']).to eq (items[0].description)
    expect(data[0]['attributes']['unit_price']).to eq (items[0].unit_price)
    expect(data[0]['attributes']['merchant_id']).to eq (items[0].merchant_id)
  end

  it 'returns an empty array if there are no merchant items' do
    id = @merchants[1].id
    get "/api/v1/merchants/#{id}/items"
    body = JSON.parse(response.body)
    expect(response).to be_successful
    expect(body['data']).to eq([])
  end

  it 'returns 404 if merchant cant be found' do
    get "/api/v1/merchants/200/items"
    body = JSON.parse(response.body)
    expect(response).to be_not_found
    expect(body['message']).to eq 'Not Found'
    expect(body['errors']).to match_array ['Could not find Merchant by this id => 200']
  end
end
require 'rails_helper'

RSpec.describe 'Items API' do
  before(:all) { create_list(:item, 50) }

  def get_items(page: 1, per: 20)
    get '/api/v1/items', params: { page: page, per_page: per }
    expect(response).to be_successful
    expect(response.status).to eq 200
    expect(response.content_type).to eq 'application/json'
    @body = JSON.parse(response.body)
  end

  it 'returns 20 items' do
    items = Item.all
    get_items
    expect(@body['data'].size).to eq 20
    expect(@body['data'][0]['id']).to eq items[0].id.to_s
    expect(@body['data'][19]['id']).to eq items[19].id.to_s
  end

  it 'returns 20 items on page two' do
    items = Item.all
    get_items(page: 2)
    expect(@body['data'].size).to eq 20
    expect(@body['data'][0]['id']).to eq items[20].id.to_s
    expect(@body['data'][19]['id']).to eq items[39].id.to_s
  end

  it 'returns 50 items when per_page is 50' do
    items = Item.all
    get_items(per: 50)
    expect(@body['data'].size).to eq 50
    expect(@body['data'][0]['id']).to eq items[0].id.to_s
    expect(@body['data'][49]['id']).to eq items[49].id.to_s
  end

  it 'returns 10 items when per_page is 10' do
    items = Item.all
    get_items(per: 10)
    expect(@body['data'].size).to eq 10
    expect(@body['data'][0]['id']).to eq items[0].id.to_s
    expect(@body['data'][9]['id']).to eq items[9].id.to_s
  end

  it 'returns empty array if no items for page' do
    first_page_with_no_results = (Merchant.count / 20.0).ceil + 1
    get_items(page: first_page_with_no_results)
    expect(@body['data'].size).to eq 0
    expect(@body['data']).to eq []
    get_items(page: 100)
    expect(@body['data'].size).to eq 0
    expect(@body['data']).to eq []
  end

  it 'returns all items if per_page is more than whats in the database' do
    get_items(per: Item.count + 1)
    expect(@body['data'].size).to eq Item.count
  end

  it 'returns 20 items for page 1 if page is 0 or not given' do
    items = Item.all
    get_items(page: 0)
    expect(@body['data'].size).to eq 20
    expect(@body['data'][0]['id']).to eq items[0].id.to_s
    expect(@body['data'][19]['id']).to eq items[19].id.to_s
    get_items(page: '')
    expect(@body['data'].size).to eq 20
    expect(@body['data'][0]['id']).to eq items[0].id.to_s
    expect(@body['data'][19]['id']).to eq items[19].id.to_s
  end
end
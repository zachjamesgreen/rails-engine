require 'rails_helper'

RSpec.describe 'Items Search API' do
  before(:all) do 
    items_under_100 = create_list(:item, 10, name: "Item #{rand(0..100)}")
    items_over_1000 = create_list(:item, 10, unit_price: rand(1000.0..10000.0))
  end

  it 'only can accept either name or min/max price' do
    get '/api/v1/items/find_all', params: { name: 'item', max_price: 100 }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['messages']).to eq('Can not process')
    expect(body['errors']).to include('You must provide either name or min/max price')
  end

  it 'has numeric min/max price' do
    get '/api/v1/items/find_all', params: { max_price: 'fdf' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['messages']).to eq('Can not process')
    expect(body['errors']).to include('min/max price must be numeric')
  end

  it 'params can not be empty or missing' do
    get '/api/v1/items/find_all'
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['messages']).to eq('Can not process')
    expect(body['errors']).to include('name or min/max price must be present')
  end

  it "returns 10 items when searching for 'item'" do
    get '/api/v1/items/find_all', params: { name: 'item' }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data'].length).to eq(10)
  end

  it 'returns 10 items when searching for min price 999' do
    get '/api/v1/items/find_all', params: { min_price: 999 }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data'].length).to eq(10)
  end

  it 'returns 10 items when searching for max price 999' do
    get '/api/v1/items/find_all', params: { max_price: 999 }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data'].length).to eq(10)
  end

  it 'returns 404 error if no items found by price' do # max price 9
    get '/api/v1/items/find_all', params: { max_price: 9 }
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['messages']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with max price of 9')
  end

  it 'returns 404 error if no items found by name' do
    get '/api/v1/items/find_all', params: { name: 'fdf' }
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['messages']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with fdf in name')
  end

end
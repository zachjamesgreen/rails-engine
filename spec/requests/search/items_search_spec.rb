require 'rails_helper'

RSpec.describe 'Items Search API' do
  before(:all) do
    10.times do |i|
      create(:item, name: "Item #{rand(0..100)}")
      create(:item, unit_price: rand(1000.0..10000.0))
    end
    # items_under_100 = create_list(:item, 10, name: "Item #{rand(0..100)}")
    # items_over_1000 = create_list(:item, 10, unit_price: rand(1000.0..10000.0))
    # items_over_1000 = rand(1000.0..10000.0).take(10).map { |u_p| create(:item, unit_price: u_p) }
  end

  it 'only can accept either name or min/max price' do
    get '/api/v1/items/find_all', params: { name: 'item', max_price: 100 }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Can not process')
    expect(body['errors']).to include('You must provide either name or min/max price')
  end

  it 'has numeric max price' do
    get '/api/v1/items/find_all', params: { max_price: 'fdf' }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Can not process')
    expect(body['errors']).to include('max price must be numeric and not 0. you sent => fdf')
  end

  it 'max price is not 0' do
    get '/api/v1/items/find_all', params: { max_price: 0 }
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Can not process')
    expect(body['errors']).to include('max price must be numeric and not 0. you sent => 0')
  end

  it 'params can not be empty or missing' do
    get '/api/v1/items/find_all'
    expect(response.status).to eq(422)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Can not process')
    expect(body['errors']).to include('name must be present')
    expect(body['errors']).to include('min/max price must be present')
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
    expect(body['message']).to eq('Not Found')
    expect(body['errors']).to include('Can not find items with price between 0 and 9')
  end

  it 'returns 404 error if no items found by name' do
    get '/api/v1/items/find_all', params: { name: 'fdf' }
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with fdf in name')
  end

end
require 'rails_helper'

RSpec.describe 'Merchant API' do
  before(:all) do
    @merchant = create(:merchant)
    @item = create(:item)
  end

  it 'GET /api/v1/merchants has correct format' do
    get '/api/v1/merchants'
    body = JSON.parse(response.body)
    expect(body.has_key?('data')).to be true
    expect(body['data']).to be_a(Array)
    data = body['data'][0]
    expect(data.has_key?('id')).to be true
    expect(data['id']).to be_instance_of String
    expect(data.has_key?('type')).to be true
    expect(data.has_key?('attributes')).to be true
    expect(data['attributes'].has_key?('name')).to be true
  end

  it 'GET /api/v1/merchants/:id has correct format' do
    get "/api/v1/merchants/#{@merchant.id}"
    body = JSON.parse(response.body)
    expect(body.has_key?('data')).to be true
    data = body['data']
    expect(data.has_key?('id')).to be true
    expect(data['id']).to be_instance_of String
    expect(data.has_key?('type')).to be true
    expect(data.has_key?('attributes')).to be true
    expect(data['attributes'].has_key?('name')).to be true
  end

  it 'GET /api/v1/items has correct format' do
    get '/api/v1/items'
    body = JSON.parse(response.body)
    expect(body.has_key?('data')).to be true
    expect(body['data']).to be_a(Array)
    data = body['data'][0]
    expect(data.has_key?('id')).to be true
    expect(data['id']).to be_instance_of String
    expect(data.has_key?('type')).to be true
    expect(data.has_key?('attributes')).to be true
    attrs = data['attributes']
    expect(attrs.has_key?('name')).to be true
    expect(attrs.has_key?('description')).to be true
    expect(attrs.has_key?('unit_price')).to be true
    expect(attrs['unit_price']).to be_instance_of Float
    expect(attrs.has_key?('merchant_id')).to be true
  end

  it 'GET /api/v1/items/:id has correct format' do
    get "/api/v1/items/#{@item.id}"
    body = JSON.parse(response.body)
    expect(body.has_key?('data')).to be true
    data = body['data']
    expect(data.has_key?('id')).to be true
    expect(data['id']).to be_instance_of String
    expect(data.has_key?('type')).to be true
    expect(data.has_key?('attributes')).to be true
    attrs = data['attributes']
    expect(attrs.has_key?('name')).to be true
    expect(attrs.has_key?('description')).to be true
    expect(attrs.has_key?('unit_price')).to be true
    expect(attrs.has_key?('merchant_id')).to be true
  end
end
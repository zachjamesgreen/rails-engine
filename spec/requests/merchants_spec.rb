require 'rails_helper'

RSpec.describe 'Merchants API' do
  before(:all) do
    150.times { create(:merchant) }
  end

  def get_merchants(page = 1, per_page = 20)
    get '/api/v1/merchants', params: { page: page, per_page: per_page }
    expect(response).to be_successful
    expect(response.content_type).to eq 'application/json'
    expect(response.status).to eq 200
    @body = JSON.parse(response.body, symbolize_names: true)
  end

  it 'has correct attributes' do
    get_merchants
    expect(@body.has_key?(:data)).to be true
    body = @body[:data][0]
    expect(body.has_key?(:id)).to be true
    expect(body.has_key?(:type)).to be true
    expect(body.has_key?(:attributes)).to be true
    expect(body[:attributes].has_key?(:name)).to be true
  end

  it 'returns 20 merchants' do
    get_merchants
    expect(@body[:data].size).to eq(20)
  end

  it 'returns page 1 if no page is given' do
    merchant = Merchant.first
    get_merchants(page = '')
    res_merchant = @body[:data].first
    expect(res_merchant[:id].to_i).to eq merchant.id
  end

  it 'returns second set of 20 merchants for page 2' do
    merchant = Merchant.all[20]
    get_merchants(page = 2)
    res_merchant = @body[:data].first
    expect(res_merchant[:id].to_i).to eq merchant.id
  end

  it 'returns all merchants if per page is bigger than total merchants size' do
    get_merchants(page = 1, per_page = Merchant.count + 1)
    expect(@body[:data].size).to eq(Merchant.count)
  end

  it 'returns no data if no data is on that page' do
    get_merchants(page = 200)
    expect(@body[:data]).to eq([])
  end
end
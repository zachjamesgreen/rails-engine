require 'rails_helper'

RSpec.describe 'Merchant Search API' do
  before(:all) { @merchant = create(:merchant, name: 'blades serrated') }
  it "finds merchant with 'ser'" do
    get '/api/v1/merchants/find', params: { name: 'ser' }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq @merchant.id.to_s
    expect(body['data']['attributes']['name']).to eq @merchant.name
  end

  it "returns first item in case-sensitive alphabetical order" do
    create(:merchant, name: 'script')
    merchant = create(:merchant, name: 'javascript')
    get '/api/v1/merchants/find', params: { name: 'script' }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq merchant.id.to_s
    expect(body['data']['attributes']['name']).to eq merchant.name
  end

  it "returns empty object if no merchant is found" do
    get '/api/v1/merchants/find', params: { name: 'fgh' }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data']).to eq({})
  end

  it 'returns 422 if name is blank' do
    get '/api/v1/merchants/find', params: { name: '' }
    body = JSON.parse(response.body)
    expect(response.status).to eq(400)
    expect(body['message']).to eq('Can not process')
    expect(body['error']).to include('Name must be present to search')
  end

  it 'returns 422 if name is not given' do
    get '/api/v1/merchants/find'
    body = JSON.parse(response.body)
    expect(response.status).to eq(400)
    expect(body['message']).to eq('Can not process')
    expect(body['error']).to include('Name must be present to search')
  end
end
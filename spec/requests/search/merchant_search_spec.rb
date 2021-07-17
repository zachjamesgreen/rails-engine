require 'rails_helper'

RSpec.describe 'Merchant Search API' do
  before(:all) { @merchant = create(:merchant, name: 'blades serrated') }
  it "finds merchant with 'ser'" do
    get '/api/v1/merchants/find', params: { name: 'ser' }
    body = JSON.parse(response.body)
    expect(body['data']['id']).to eq @merchant.id
    expect(body['data']['attributes']['name']).to eq @merchant.name
  end

  it 'returns 422 if name is blank' do
    get '/api/v1/merchants/find', params: { name: '' }
    body = JSON.parse(response.body)
    expect(response.status).to eq(422)
    expect(body['message']).to eq('Please provide a name')
    expect(body['errors']).to include('Name must be present to search')
  end

  it 'returns 422 if name is not given' do
    get '/api/v1/merchants/find'
    body = JSON.parse(response.body)
    expect(response.status).to eq(422)
    expect(body['message']).to eq('Please provide a name')
    expect(body['errors']).to include('Name must be present to search')
  end

  it "finds 3 merchants with 'ser'"
end
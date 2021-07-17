require 'rails_helper'

RSpec.describe 'Merchant API' do
  before(:all) do
    @merchants = create_list(:merchant, 5)
  end

  def get_merchant(id)
    get "/api/v1/merchants/#{id}"
    expect(response).to be_successful
    expect(response.content_type).to eq 'application/json'
    expect(response.status).to eq 200
    @body = JSON.parse(response.body)
  end

  it 'returns one merchant' do
    merchant = @merchants.first
    get_merchant merchant.id
    body = @body['data']
    expect(body['id'].to_i).to eq merchant.id
    expect(body['type']).to eq 'merchant'
    expect(body['attributes']['name']).to eq merchant.name
  end

  it 'returns 404 if merchant cant be found' do
    get '/api/v1/merchants/0'
    expect(response).to be_not_found
    body = JSON.parse(response.body)
    expect(body['message']).to eq 'Not Found'
    expect(body['errors']).to match_array ['Could not find Merchant by this id => 0']
  end
end
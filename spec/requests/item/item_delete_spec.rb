require 'rails_helper'

RSpec.describe 'Delete Item API' do
  before(:each) { @item = create(:item) }

  it 'deletes an item' do
    delete "/api/v1/items/#{@item.id}"
    expect(response.status).to eq(204)
    expect {Item.find(@item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns error if item is not found' do
    delete "/api/v1/items/57"
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with id => 57')
  end
end
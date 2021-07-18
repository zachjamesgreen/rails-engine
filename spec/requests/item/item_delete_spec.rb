require 'rails_helper'

RSpec.describe 'Delete Item API' do
  before(:each) { @item = create(:item) }

  xit 'deletes an item' do
    delete "/api/v1/items/#{@item.id}"
    expect(response.status).to eq(204)
    expect {Item.find(@item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit 'returns error if item is not found' do
    delete "/api/v1/items/57"
    expect(response.status).to eq(404)
    body = JSON.parse(response.body)
    expect(body['message']).to eq('Not Found')
    expect(body['errors']).to include('Can not find item with id => 57')
  end

  it 'deletes invoices if its the only item on it' do
    invs = create_list(:invoice, 10)
    invs.each { |inv| create(:invoice_item, item: @item, invoice: inv) }
    inv2 = create(:invoice)
    create(:invoice_item, item: @item, invoice: inv2)
    create(:invoice_item, invoice: inv2)

    delete "/api/v1/items/#{@item.id}"
    invs.each do |inv|
      expect {Invoice.find(inv.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    expect {Invoice.find(inv2.id)}.to_not raise_error
  end
end
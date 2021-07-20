require 'rails_helper'

RSpec.describe "WeeklyRevenue" do
  it 'returns revenue by week sort asc by week' do
    (0..100).each do |i|
      invoice = create(:invoice, status: 'shipped', created_at: Time.now - i.days)
      create(:invoice_item, invoice: invoice)
      create(:transaction, invoice: invoice, result: 'success')
    end
    get '/api/v1/revenue/weekly'
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['data'].size).to eq(16)
    data = body['data'][0]
    expect(data).to have_key('id')
    expect(data['id']).to be(nil)
    expect(data).to have_key('type')
    expect(data['type']).to eq('weekly_revenue')
    expect(data).to have_key('attributes')
    expect(data['attributes']).to be_instance_of(Hash)
    expect(data['attributes']).to have_key('week')
    expect(data['attributes']).to have_key('revenue')

  end
end
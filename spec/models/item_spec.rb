require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a valid factory' do
    expect(create(:item)).to be_valid
  end

  it {should belong_to(:merchant)}
  it {should have_many(:invoice_items)}

  it {should validate_presence_of(:name).with_message('Can not create item without a name') }
  it {should validate_presence_of(:merchant_id).with_message('Can not create item without a merchant id') }
  it {should validate_presence_of(:unit_price).with_message('Can not create item without a unit price') }
  it {should validate_numericality_of(:unit_price).with_message('Unit price must be numeric') }
  it {should validate_presence_of(:merchant).with_message('Merchant not found. Can not create item without a merchant') }
end
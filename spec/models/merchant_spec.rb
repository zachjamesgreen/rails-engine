require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it 'has a valid factory' do
    expect(create(:merchant)).to be_valid
  end

  it {should have_many(:invoices)}
  it {should have_many(:items)}
end
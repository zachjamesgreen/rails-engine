require 'rails_helper'

RSpec.describe 'Merchant Search API' do
  it "finds 3 merchants with 'ser'" do
    get '/api/v1/merchants/search', params:
end
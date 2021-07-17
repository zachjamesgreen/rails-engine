class Api::V1::CustomersController < ApplicationController
  def index
    customers = Customer.all
    render json: {
      count: customers.count,
      customers: customers
    }
  end
end

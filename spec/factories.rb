FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
  end

  factory :item do
    name { Faker::Lorem.sentence(word_count: 2) }
    description { Faker::Lorem.sentence }
    unit_price { rand(10.0..100.0).round(2) }
    merchant
  end

  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end

  factory :invoice do
    customer
    merchant
    created_at { Faker::Date.between(from: 0.days.ago, to: 60.days.ago) }
    status { ['shipped', 'returned', 'packaged'].sample }
  end

  factory :transaction do
    invoice
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { Faker::Date.between(from: Date.today, to: Date.today + 30) }
    result { ['failed', 'refunded', 'success'].sample }
  end

  factory :invoice_item do
    item
    invoice
    quantity { rand(1..5) }
    unit_price { item.unit_price }
  end
end
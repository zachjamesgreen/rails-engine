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
end
# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence(word_count: rand(1..3)) }
    thumbnail { 'https://cdn-cosmos.bluesoft.com.br/products/7891910000197' }
    width { Faker::Number.decimal(l_digits: 2) }
    height { Faker::Number.decimal(l_digits: 2) }
    length { Faker::Number.decimal(l_digits: 2) }
    net_weight { Faker::Number.decimal(l_digits: 2) }
    gross_weight { Faker::Number.decimal(l_digits: 2) }
    price { 'R$ 2,99 a R$ 5,10' }
    avg_price { Faker::Number.decimal(l_digits: 2) }
    max_price { Faker::Number.decimal(l_digits: 2) }
    min_price { Faker::Number.decimal(l_digits: 2) }
    origin { 'Cosmos' }
    barcode_image { 'https://api.cosmos.bluesoft.com.br/products/barcode/D215D0FAC1ACAEF6B65EE7ED9820DD38.png' }
    brand { build(:brand) }
    global_product_classification { build(:global_product_classification) }
    mercosul_common_nomenclature { build(:mercosul_common_nomenclature) }
    specification_code_for_tax_substitution { build(:specification_code_for_tax_substitution) }
    global_trade_item_numbers { build_list(:global_trade_item_numbers, 1) }
  end
end

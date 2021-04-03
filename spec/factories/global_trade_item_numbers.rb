# frozen_string_literal: true

FactoryBot.define do
  factory :global_trade_item_number do
    number { Faker::Number.number(digits: 13) }
    type_packaging { %w[Unidade Caixa Fardo].sample }
    quantity_packaging { Faker::Number.positive.to_i }
    ballast { Faker::Number.positive.to_i }
    layer { Faker::Number.positive.to_i }
  end
end

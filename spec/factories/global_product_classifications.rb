# frozen_string_literal: true

FactoryBot.define do
  factory :global_product_classification do
    code { Faker::Number.number(digits: 8) }
    description { Faker::Quotes::Chiquito.expression }
  end
end

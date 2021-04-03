# frozen_string_literal: true

FactoryBot.define do
  factory :specification_code_for_tax_substitution do
    code { Faker::Number.number(digits: 8) }
    description { Faker::Quotes::Chiquito.expression }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :mercosul_common_nomenclature do
    code { Faker::Number.number(digits: 8) }
    description { Faker::Quotes::Chiquito.expression }
    full_description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) }
  end
end

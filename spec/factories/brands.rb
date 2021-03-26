# frozen_string_literal: true

FactoryBot.define do
  factory :brand do
    name { Faker::Company.name }
    picture_url { Faker::Company.logo }
  end
end

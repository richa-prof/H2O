# frozen_string_literal: true

FactoryBot.define do
  factory :pax do
    nome  { |_n| Faker::Name.name_with_middle }
    idade { |_n| Faker::Number.between(0, 90) }
    doc   { |_n| Faker::Lorem.characters(10) }
    association :itinerary
  end
end

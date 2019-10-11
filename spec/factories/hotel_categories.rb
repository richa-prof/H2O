# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_category do
    association :hotel, factory: :hotel
    association :category, factory: :category
  end
end

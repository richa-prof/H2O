# frozen_string_literal: true

FactoryBot.define do
  factory :tour_price_type_locale do
    locale      { 'en-US' }
    nome        { 'Low Season' }
    association :tour_price_type
  end
end

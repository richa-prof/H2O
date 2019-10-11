# frozen_string_literal: true

FactoryBot.define do
  factory :meal_locale do
    locale      { 'en-US' }
    nome        { 'Breakfast only' }
    association :meal
  end
end

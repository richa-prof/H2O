# frozen_string_literal: true

FactoryBot.define do
  factory :meal do
    nome  { 'Breakfast only' }
    ordem { 1 }

    after(:create) do |meal|
      create(:meal_locale, meal: meal)
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :persona_day_by_day do
    day_order { 2 }
    association :persona, :with_locales
    association :tour, :with_locales
    association :block, :with_locales
  end
end

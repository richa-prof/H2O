# frozen_string_literal: true

FactoryBot.define do
  factory :tour_facility do
    association :tour
    association :facility
  end
end

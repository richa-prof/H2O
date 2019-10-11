# frozen_string_literal: true

FactoryBot.define do
  factory :tour_price do
    inicio         { DateTime.current - 5.months }
    fim            { DateTime.current + 5.months }
    idade_crianca  { 5 }
    idade_crianca2 { 12 }
    preco_crianca  { nil }
    preco_crianca2 { 12.12 }
    preco_adulto   { 25.25 }
    association :tour
    association :tour_price_type
  end
end

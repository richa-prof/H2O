# frozen_string_literal: true

FactoryBot.define do
  factory :tour_extra_price do
    inicio         { Date.current - 5.months }
    fim            { Date.current + 5.months }
    idade_crianca  { 5 }
    idade_crianca2 { 10 }
    preco_crianca  { 5 }
    preco_crianca2 { 7 }
    preco_adulto   { 50 }
    preco_unidade  { 340 }
    association :tour_extra
  end
end

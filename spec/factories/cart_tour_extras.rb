# frozen_string_literal: true

FactoryBot.define do
  factory :cart_tour_extra do
    adults_qty    { 3 }
    children_qty  { 1 }
    children2_qty { 2 }
    unit_qty      { 1 }
    association :cart
    association :tour_extra
  end
end

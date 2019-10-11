# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    titulo  { 'Why did the chicken cross the road?' }
    texto   { 'To get to the other side!' }
    locale  { 'en-US' }
    ordem   { 3 }
    association :institutional
  end
end

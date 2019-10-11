# frozen_string_literal: true

FactoryBot.define do
  factory :ability_locale do
    locale { 'en-US' }
    nome   { 'Easy' }
    association :ability
  end
end

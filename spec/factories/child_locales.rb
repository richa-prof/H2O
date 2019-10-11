# frozen_string_literal: true

FactoryBot.define do
  factory :child_locale do
    locale      { 'en-US' }
    nome        { '10 years and up' }
    association :child
  end
end

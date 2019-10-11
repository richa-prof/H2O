# frozen_string_literal: true

FactoryBot.define do
  factory :block_locale do
    locale      { 'en-US' }
    nome        { 'Morning' }
    association :block
  end
end

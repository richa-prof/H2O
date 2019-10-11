# frozen_string_literal: true

FactoryBot.define do
  factory :facility_locale do
    locale      { 'en-US' }
    nome        { 'Easy' }
    association :facility
  end
end

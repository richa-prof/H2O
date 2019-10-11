# frozen_string_literal: true

FactoryBot.define do
  factory :staff_locale do
    locale      { 'en-US' }
    cargo       { 'Customer Success' }
    texto       { 'Loves to snorkel!' }
    association :staff
  end
end

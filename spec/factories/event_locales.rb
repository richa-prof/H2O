# frozen_string_literal: true

FactoryBot.define do
  factory :event_locale do
    locale      { 'en-US' }
    name        { 'Name My Event' }
    description { 'Something very fun for everyone.' }
    association :event

    trait :pt_br do
      locale { 'pt-BR' }
    end
  end
end

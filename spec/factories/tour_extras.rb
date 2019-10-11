# frozen_string_literal: true

FactoryBot.define do
  factory :tour_extra do
    nome         { 'A Little Something Extra' }
    tipo_estoque { nil }
    eh_almoco    { nil }
    association :tour
    association :tour_extra_price_type, :person_pt_br

    trait :pt_br do
      after(:create) do |tour_extra|
        create(:tour_extra_locale, :pt_br, tour_extra: tour_extra)
      end
    end

    trait :pt_br_with_price do
      after(:create) do |tour_extra|
        create(:tour_extra_price, tour_extra: tour_extra)
        create(:tour_extra_locale, :pt_br, tour_extra: tour_extra)
      end
    end
  end
end

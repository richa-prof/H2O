# frozen_string_literal: true

FactoryBot.define do
  factory :tour_extra_price_type do
    trait :person_pt_br do
      id   { 1 }
      nome { 'Pessoa' }
      after(:create) do |tour_extra_price_type|
        create(:tour_extra_price_type_locale, tour_extra_price_type: tour_extra_price_type)
      end
    end

    trait :unit_pt_br do
      id   { 2 }
      nome { 'Unidade' }
      after(:create) do |tour_extra_price_type|
        create(:tour_extra_price_type_locale, :pt_br, tour_extra_price_type: tour_extra_price_type)
      end
    end
  end
end

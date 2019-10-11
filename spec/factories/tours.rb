# frozen_string_literal: true

FactoryBot.define do
  factory :tour do
    nome              { 'Some Random Tour' }
    link              { |_n| Faker::Lorem.characters(10) }
    imagem_1          { 'test_imagem_1.png' }
    video             { Faker::Lorem.characters(7) }
    status            { true }
    localidade        { 'Jupiter' }
    exibir_site       { true }
    cdgbtms_atividade { 9_900_880_077_006_600 }
    cdgbtms_atrativo  { 5_500_440_033_002_200 }
    btms_online       { true }
    ordem             { 1 }
    duration_in_min   { 120 }
    association :lunch
    association :child
    association :ability

    trait :with_locale do
      after(:create) do |tour|
        create(:tour_locale, tour: tour)
      end
    end

    trait :with_pt_br_locale do
      after(:create) do |tour|
        create(:tour_locale, :pt_br, tour: tour)
      end
    end

    trait :pt_br_with_price do
      after(:create) do |tour|
        create(:tour_locale, :pt_br, tour: tour)
        create(:tour_price, tour: tour)
      end
    end

    trait :with_locales do
      after(:create) do |tour|
        create(:tour_locale, tour: tour)
        create(:tour_locale, :pt_br, tour: tour)
      end
    end

    trait :with_price do
      after(:create) do |tour|
        create(:tour_price, tour: tour)
      end
    end
  end
end

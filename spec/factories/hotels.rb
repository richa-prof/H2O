# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    nome                   { 'The Love Shack' }
    link                   { |_n| Faker::Lorem.characters(10) }
    imagem_1               { 'test_imagem_1.png' }
    video                  { Faker::Lorem.characters(7) }
    localidade             { 'Mars' }
    exibir_site            { true }
    ordem                  { 1 }
    distancia_do_centro    { 75 }
    centro_de              { 'Athens, Georgia' }
    numero_de_apartamentos { 35 }
    association :meal

    trait :with_locale do
      after(:create) do |hotel|
        create(:hotel_locale, hotel: hotel)
      end
    end

    trait :pt_br do
      after(:create) do |hotel|
        create(:hotel_locale, :pt_br, hotel: hotel)
      end
    end
  end
end

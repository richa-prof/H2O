# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_locale do
    locale            { 'en-US' }
    nome              { Faker::StarWars.vehicle }
    metatag_titulo    { Faker::Friends.location }
    metatag_descricao { Faker::Friends.quote }
    descricao         { Faker::StarWars.quote }
    association       :hotel

    after(:create) do |hotel_locale|
      create(:meal_locale, meal: hotel_locale.hotel.meal, locale: 'en-US')
    end

    trait :pt_br do
      locale { 'pt-BR' }
      after(:create) do |hotel_locale|
        create(:meal_locale, meal: hotel_locale.hotel.meal, locale: 'pt-BR')
      end
    end
  end
end

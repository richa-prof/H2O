# frozen_string_literal: true

FactoryBot.define do
  factory :tour_locale do
    locale             { 'en-US' }
    nome               { Faker::StarWars.vehicle }
    metatag_titulo     { Faker::Simpsons.location }
    metatag_descricao  { Faker::Friends.quote }
    descricao          { Faker::StarWars.quote }
    association        :tour

    trait :pt_br do
      locale { 'pt-BR' }
      after(:create) do |tour_locale|
        create(:lunch_locale, lunch: tour_locale.tour.lunch, locale: 'pt-BR')
        create(:child_locale, child: tour_locale.tour.child, locale: 'pt-BR')
        create(:ability_locale, ability: tour_locale.tour.ability, locale: 'pt-BR')
      end
    end
  end
end

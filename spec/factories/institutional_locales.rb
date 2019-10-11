# frozen_string_literal: true

FactoryBot.define do
  factory :institutional_locale do
    titulo            { Faker::Superhero.prefix }
    titulo_menu       { Faker::Superhero.suffix }
    texto             { Faker::Superhero.power }
    metatag_titulo    { Faker::Superhero.name }
    metatag_descricao { Faker::Superhero.descriptor }
    locale            { 'en-US' }
    association       :institutional

    trait :pt_br do
      locale { 'pt-BR' }
    end
  end
end

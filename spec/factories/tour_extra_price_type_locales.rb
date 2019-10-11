# frozen_string_literal: true

FactoryBot.define do
  factory :tour_extra_price_type_locale do
    locale      { 'en-US' }
    nome        { 'Person OR Unit' }
    association :tour_extra_price_type

    trait :pt_br do
      locale { 'pt-BR' }
      nome   { 'Pessoa OU Unidade' }
    end
  end
end

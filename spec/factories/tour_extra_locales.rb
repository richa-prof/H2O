# frozen_string_literal: true

FactoryBot.define do
  factory :tour_extra_locale do
    locale    { 'en-US' }
    titulo    { 'Something Extra' }
    descricao { 'This little something will help you have more fun.' }
    association :tour_extra

    trait :pt_br do
      locale    { 'pt-BR' }
      titulo    { 'Algo Mais' }
      descricao { 'Este algo mais é para você aproveitar mais.' }
    end
  end
end

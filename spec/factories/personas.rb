# frozen_string_literal: true

FactoryBot.define do
  factory :persona do
    nome      { 'Super Atleta' }
    ordem     { 1 }
    icon_name { 'test_imagem_1.png' }

    trait :with_locales do
      after(:create) do |persona|
        create(:persona_locale, persona: persona)
        create(:persona_locale, persona: persona, locale: 'pt-BR', nome: 'Super Atleta')
      end
    end
  end
end

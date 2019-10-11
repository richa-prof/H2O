# frozen_string_literal: true

FactoryBot.define do
  factory :banner do
    ordem  { 1 }
    tipo   { 'This cool new thing.' }
    imagem { 'test_imagem_1.png' }

    trait :with_locales do
      after(:create) do |banner|
        create(:banner_locale, banner: banner, locale: 'en-US')
        create(:banner_locale, banner: banner, locale: 'pt-BR')
      end
    end
  end
end

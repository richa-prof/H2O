# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    nome        { 'Amazing Tours' }
    link        { |_n| Faker::Lorem.characters(10) }
    exibir_site { true }

    trait :with_locale do
      after(:create) do |category|
        create(:cat_locale, category: category)
      end
    end

    trait :with_pt_br_locale do
      after(:create) do |category|
        category_locale = create(:category_locale, locale: 'pt-BR')
        create(:cat_locale, category: category, category_locale: category_locale)
      end
    end
  end
end

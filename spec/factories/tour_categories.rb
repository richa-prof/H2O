# frozen_string_literal: true

FactoryBot.define do
  factory :tour_category do
    association :tour
    association :category

    trait :with_locales do
      after(:create) do |tour_category|
        create(:tour_locale, tour: tour_category.tour)
        create(:tour_locale, :pt_br, tour: tour_category.tour)

        create(:cat_locale, category: tour_category.category)
        category_locale = create(:category_locale, locale: 'pt-BR')
        create(:cat_locale, category: tour_category.category, category_locale: category_locale)
      end
    end

    trait :with_locales_and_prices do
      after(:create) do |tour_category|
        create(:tour_locale, tour: tour_category.tour)
        create(:tour_locale, :pt_br, tour: tour_category.tour)
        create(:tour_price, tour: tour_category.tour)

        create(:cat_locale, category: tour_category.category)
        category_locale = create(:category_locale, locale: 'pt-BR')
        create(:cat_locale, category: tour_category.category, category_locale: category_locale)
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :lunch do
    nome  { 'Included' }
    ordem { 1 }

    after(:create) do |lunch|
      create(:lunch_locale, lunch: lunch)
      create(:lunch_locale, lunch: lunch, locale: 'pt-BR')
    end
  end
end

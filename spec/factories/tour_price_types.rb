# frozen_string_literal: true

FactoryBot.define do
  factory :tour_price_type do
    nome { 'Low Season' }
    initialize_with { TourPriceType.find_or_create_by(nome: nome) }

    after(:create) do |tour_price_type|
      create(:tour_price_type_locale, tour_price_type: tour_price_type)
      create(:tour_price_type_locale, tour_price_type: tour_price_type, locale: 'pt-BR', nome: 'Baixa Temporada')
    end
  end
end

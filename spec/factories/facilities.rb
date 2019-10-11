# frozen_string_literal: true

FactoryBot.define do
  factory :facility do
    nome      { 'Restroom' }
    ordem     { 1 }
    icon_name { 'toilet' }

    after(:create) do |facility|
      create(:facility_locale, facility: facility)
      create(:facility_locale, facility: facility, locale: 'pt-BR')
    end
  end
end

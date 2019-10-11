# frozen_string_literal: true

FactoryBot.define do
  factory :category_locale do
    locale            { 'en-US' }
    nome              { 'Very fun tours' }
    link              { 'very-fun-tours' }
    descricao         { Faker::Lorem.paragraphs(5) }
    metatag_titulo    { |_n| Faker::University.name }
    metatag_descricao { Faker::Lorem.paragraphs(2) }
  end
end

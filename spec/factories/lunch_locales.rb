# frozen_string_literal: true

FactoryBot.define do
  factory :lunch_locale do
    locale      { 'en-US' }
    nome        { 'Always included' }
    nome_menu   { 'Included' }
    association :lunch
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :ability do
    nome  { 'Easy' }
    ordem { 1 }

    after(:create) do |ability|
      create(:ability_locale, ability: ability)
    end
  end
end

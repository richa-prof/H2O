# frozen_string_literal: true

FactoryBot.define do
  factory :block do
    nome  { |_n| Faker::Lorem.characters(5) }

    trait :with_locales do
      after(:create) do |block|
        create(:block_locale, block: block)
        create(:block_locale, block: block, locale: 'pt-BR', nome: 'Manhã')
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :child do
    nome  { '10 years and up' }
    ordem { 1 }

    after(:create) do |child|
      create(:child_locale, child: child)
      create(:child_locale, child: child, locale: 'pt-BR')
    end
  end
end

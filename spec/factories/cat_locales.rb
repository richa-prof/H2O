# frozen_string_literal: true

FactoryBot.define do
  factory :cat_locale do
    association :category
    association :category_locale
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :special_deal do
    name                { 'Oh, my! What a deal!' }
    start_date          { Date.current + 1.week }
    end_date            { Date.current + 2.weeks }
    photo_home          { 'test_imagem_1.png' }
    photo_page          { 'test_imagem_1.png' }
    true_price          { 9.99 }
    discounted_price    { 8.88 }
    link                { 'what-a-deal' }
    display_start_date  { Date.current - 1.week }
    display_end_date    { Date.current + 1.day }
    association :hotel, :with_locale

    trait :pt_br do
      after(:create) do |special_deal|
        create(:hotel_locale, hotel: special_deal.hotel, locale: 'pt-BR')
      end
    end
  end
end

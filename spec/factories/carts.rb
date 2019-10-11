# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    localizacao { 'Hotel Transilvânia' }
    telefone    { '+55 (12) 1234-1234' }
    subtotal    { 90 }
    desconto    { 0 }
    total       { 90 }
    data        { DateTime.current }
    start_date  { DateTime.current + 3.days }
    end_date    { DateTime.current + 5.days }
    association :user

    trait :with_pax do
      after(:create) do |cart|
        create_list(:cart_passenger, 3, cart: cart)
      end
    end

    trait :with_item_and_pax do
      after(:create) do |cart|
        create(:cart_item, cart: cart)
        create(:cart_passenger, cart: cart)
      end
    end

    trait :with_item do
      after(:create) do |cart|
        create(:cart_item, cart: cart)
      end
    end

    trait :with_items_and_pax do
      after(:create) do |cart|
        create_list(:cart_item, 3, cart: cart)
        create_list(:cart_passenger, 3, cart: cart)
      end
    end

    trait :with_pax_and_reserved_item do
      after(:create) do |cart|
        create(:cart_passenger, cart: cart)
        create(:cart_item, cart: cart, reserva: 'ABCXYZ')
      end
    end

    trait :converted do
      after(:create) do |cart|
        create(:itinerary, user: cart.user, cart: cart)
      end
    end

    trait :with_pax_and_btms_item do
      after(:create) do |cart|
        create(:cart_passenger, cart: cart)
        create(:cart_item, :btms, cart: cart)
      end
    end

    trait :with_pax_and_stock_item do
      after(:create) do |cart|
        create(:cart_passenger, cart: cart)
        create(:cart_item, :stock, cart: cart)
      end
    end
  end
end

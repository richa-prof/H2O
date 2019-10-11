FactoryBot.define do
  factory :cart_hotel do
    request_echo_token { '_h2o_token_0987654321' }
    start_date         { Date.current }
    end_date           { Date.current + 2.days }
    adults             { 2 }
    children_ages      { '' }
    number_of_nights   { 2 }
    room_type_name     { 'Super Luxo' }
    room_selected      { '1234-5678-0' }
    sale_price         { 99.99 }
    association :cart
    association :hotel

    trait :pt_br do
      after(:create) do |cart_hotel|
        create(:hotel_locale, :pt_br, hotel: cart_hotel.hotel)
      end
    end
  end
end
